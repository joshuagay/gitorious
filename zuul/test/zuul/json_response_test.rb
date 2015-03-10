# encoding: utf-8
#--
#   Copyright (C) 2013 Gitorious AS
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++
require "test_helper"
require "zuul/json_response"
require "use_case"
require "ostruct"

describe Zuul::JSONResponse do
  it "defaults to status 200" do
    response = Zuul::JSONResponse.new(nil, nil)
    assert_equal 200, response.status
  end

  it "defaults to content-type: application/json" do
    response = Zuul::JSONResponse.new(nil, nil)
    assert_equal "application/json", response.content_type
  end

  it "encodes hash as JSON" do
    response = Zuul::JSONResponse.new(nil, { :name => "Freddy" })
    assert_equal({ "name" => "Freddy" }, JSON.parse(response.body))
  end

  it "includes Content-Length and Etag headers" do
    response = Zuul::JSONResponse.new(nil, { :name => "Freddy" })
    headers = {
      "Content-Length" => "17",
      "Content-Type" => "application/json",
      "Etag" => "1a0437b6879e4f45cea79b3788e4ec3c"
    }
    assert_equal(headers, response.headers)
  end

  describe "#for" do
    it "returns wrapper for hash yielding outcome" do
      outcome = UseCase::SuccessfulOutcome.new({ :name => "John" })
      response = Zuul::JSONResponse.for(nil, outcome)
      assert_equal "John", JSON.parse(response.body)["name"]
    end
  end

  describe Zuul::HALResponse do
    before { @res = Zuul::Test::Response.new }

    it "defaults to hal+json content type" do
      result = UseCase::SuccessfulOutcome.new({})
      response = Zuul::JSONResponse.for(@res, result)

      assert_equal "application/hal+json", response.content_type
    end

    it "includes profile with content type" do
      result = OpenStruct.new(:profile => "user")
      outcome = UseCase::SuccessfulOutcome.new(result)
      response = Zuul::JSONResponse.for(@res, outcome)

      ct = "application/hal+json; profile=http://localhost/schema/user"
      assert_equal ct, response.content_type
    end

    it "includes links in body" do
      result = OpenStruct.new(:to_hash => { :name => "Chris" },
                              :links => { "self" => nil, "find_user" => nil })
      outcome = UseCase::SuccessfulOutcome.new(result)
      response = Zuul::JSONResponse.for(@res, outcome)

      url = "http://localhost"
      links = { "self" => url, "find_user" => url }
      expected = { "name" => "Chris", "_links" => links }
      assert_equal expected, JSON.parse(response.body)
    end

    it "embeds collections" do
      outcome = UseCase::SuccessfulOutcome.new({
          "_embedded" => {
            "gts:something" => [OpenStruct.new(:to_hash => { :name => "Chris" },
                :links => { "self" => nil, "find_user" => nil })]
          }
        })
      response = Zuul::JSONResponse.for(@res, outcome)

      url = "http://localhost"
      links = { "self" => url, "find_user" => url }
      expected = {
        "_embedded" => {
          "gts:something" => [{ "name" => "Chris", "_links" => links }]
        },
        "_links" => {}
      }
      assert_equal expected, JSON.parse(response.body)
    end
  end

  describe Zuul::ErrorResponse do
    before do
      @error = UseCase::FailedOutcome.new({ :email => "Missing" })
    end

    it "defaults to status 400" do
      response = Zuul::JSONResponse.for(nil, @error)

      assert_equal 400, response.status
    end

    it "uses custom mime type for errors" do
      response = Zuul::JSONResponse.for(nil, @error)

      assert_equal "application/vnd.gitorious.error+json", response.content_type
    end

    it "encodes error body" do
      response = Zuul::JSONResponse.for(nil, @error)

      expected = { "type" => "validation_error", "message" => { "email" => "Missing" } }
      assert_equal expected, JSON.parse(response.body)
    end
  end
end
