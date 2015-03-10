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
require "zuul/endpoint/memberships"
require "ostruct"

class TestGroup
  def self.find(id)
    new
  end

  def memberships
    user = OpenStruct.new(:login => "cjohansen")
    group = OpenStruct.new(:name => "gitorians")
    [OpenStruct.new(:id => 13, :group => group, :user => user, :role => "member")]
  end
end

class TestCreateMembership
  def initialize(app, team, user)
  end

  def execute(params)
    UseCase::SuccessfulOutcome.new([
        OpenStruct.new(:id => 1, :role => params[:role_name])
      ])
  end
end

describe Zuul::Endpoint::Memberships do
  before do
    @req = Zuul::Test::Request.new
    @res = Zuul::Test::Response.new
  end

  it "generates link" do
    endpoint = Zuul::Endpoint::Memberships.new(TestCreateMembership, TestGroup)

    assert_equal("/teams/42/memberships", endpoint.link_for(OpenStruct.new(:id => 42)))
  end

  it "responds to OPTIONS request" do
    endpoint = Zuul::Endpoint::Memberships.new(TestCreateMembership, TestGroup)
    response = endpoint.options(@req, @res)

    assert Hash === response
    assert_equal "GET, POST, OPTIONS", @res.headers["Allow"]
  end

  it "responds to POST request" do
    endpoint = Zuul::Endpoint::Memberships.new(TestCreateMembership, TestGroup)
    req = Zuul::Test::Request.new(:id => 13, :role => "member")
    def req.current_user; nil; end
    response = endpoint.post(req, @res)

    assert_equal 1, response.result[0].id
    assert_equal "member", response.result[0].role
  end

  it "responds to GET request" do
    endpoint = Zuul::Endpoint::Memberships.new(TestCreateMembership, TestGroup)
    req = Zuul::Test::Request.new(:id => 13)
    response = endpoint.get(req, @res)

    assert_equal 13, response.result[0].id
    assert_equal "member", response.result[0].role
  end
end
