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
require "zuul/endpoint/api_index"

describe Zuul::Endpoint::APIIndex do
  before do
    @req = Zuul::Test::Request.new
    @res = Zuul::Test::Response.new
  end

  it "responds to OPTIONS request" do
    endpoint = Zuul::Endpoint::APIIndex.new([])
    response = endpoint.options(@req, @res)

    assert Hash === response
    assert_equal "GET, OPTIONS", @res.headers["Allow"]
  end

  it "responds to GET request" do
    endpoint = Zuul::Endpoint::APIIndex.new([])
    response = endpoint.get(@req, @res)

    assert_equal [], response.result.links
  end
end
