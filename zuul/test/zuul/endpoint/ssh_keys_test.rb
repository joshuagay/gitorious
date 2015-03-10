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
require "zuul/endpoint/ssh_keys"
require "ostruct"
require "use_case"

class TestCreateSshKey
  def initialize(app, user)
  end

  def execute(params)
    UseCase::SuccessfulOutcome.new(OpenStruct.new(:id => 666, :key => params[:key]))
  end
end

describe Zuul::Endpoint::SshKeys do
  before do
    @req = Zuul::Test::Request.new
    @res = Zuul::Test::Response.new
  end

  it "generates link" do
    endpoint = Zuul::Endpoint::SshKeys.new(TestCreateSshKey)

    user = OpenStruct.new(:id => 42)
    assert_equal("/users/42/ssh_keys", endpoint.link_for(user))
  end

  it "responds to OPTIONS request" do
    endpoint = Zuul::Endpoint::SshKeys.new(TestCreateSshKey)
    response = endpoint.options(@req, @res)

    assert Hash === response
    assert_equal "POST, OPTIONS", @res.headers["Allow"]
  end

  it "responds to POST request" do
    endpoint = Zuul::Endpoint::SshKeys.new(TestCreateSshKey)
    response = endpoint.post(Zuul::Test::Request.new(:key => "mm"), @res)

    assert_equal "mm", response.success.to_hash[:key]
  end
end
