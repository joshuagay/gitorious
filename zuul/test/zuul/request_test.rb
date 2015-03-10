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
require "json"
require "zuul/request"

describe Zuul::Request do
 describe "#for" do
    it "returns form encoded request when no Content-Type" do
      req = Zuul::Test::Request.new

      assert Zuul::Request.for(req, {}).is_a?(Zuul::FormEncodedRequest)
    end

    it "returns form encoded request when Content-Type is form encoded" do
      req = Zuul::Test::Request.new
      req.content_type = "application/x-www-form-encoded"

      assert Zuul::Request.for(req, {}).is_a?(Zuul::FormEncodedRequest)
    end

    it "returns JSON request when Content-Type is application/json" do
      req = Zuul::Test::Request.new
      req.content_type = "application/json"

      assert Zuul::Request.for(req, {}).is_a?(Zuul::JSONRequest)
    end

    it "ignores content-type parameters" do
      req = Zuul::Test::Request.new
      req.content_type = "application/json; encoding=utf-8"

      assert Zuul::Request.for(req, {}).is_a?(Zuul::JSONRequest)
    end
  end

  describe "JSONRequest" do
    it "parses request body" do
      req = Zuul::Test::Request.new({}, JSON.dump({ "ay" => "yes" }))
      req.content_type = "application/json; encoding=utf-8"
      req = Zuul::Request.for(req, {})

      assert_equal "yes", req.params["ay"]
    end

    it "raises exception if body is not valid JSON" do
      req = Zuul::Test::Request.new({}, "wrong=encoding")
      req.content_type = "application/json; encoding=utf-8"

      assert_raises Zuul::InvalidRequest do
        Zuul::Request.for(req, {})
      end
    end
  end
end
