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
require "zuul/endpoint/repository_lookup"
require "ostruct"

class TestRepositoryFinder
  def by_slug(slug)
    OpenStruct.new(:name => slug.split("/")[1], :owner => OpenStruct.new(:id => 42))
  end
end

class EmptyRepositoryFinder
  def by_slug(slug); nil; end
end

describe Zuul::Endpoint::RepositoryLookup do
  before do
    @res = Zuul::Test::Response.new
  end

  it "generates link" do
    endpoint = Zuul::Endpoint::RepositoryLookup.new(TestRepositoryFinder.new)

    link = { "href" => "/repository/{slug}", "templated" => true }
    assert_equal(link, endpoint.link_for(nil))
  end

  it "responds to OPTIONS request" do
    endpoint = Zuul::Endpoint::RepositoryLookup.new(TestRepositoryFinder.new)
    response = endpoint.options(Zuul::Test::Request.new, @res)

    assert Hash === response
    assert_equal "GET, OPTIONS", @res.headers["Allow"]
  end

  it "responds to GET request" do
    endpoint = Zuul::Endpoint::RepositoryLookup.new(TestRepositoryFinder.new)
    response = endpoint.get(Zuul::Test::Request.new(:project => "some", :repository => "stuff"), @res)

    assert_equal "stuff", response.success.to_hash[:name]
  end

  it "responds to GET request with escaped slash" do
    endpoint = Zuul::Endpoint::RepositoryLookup.new(TestRepositoryFinder.new)
    response = endpoint.get(Zuul::Test::Request.new(:slug => "some%2Fstuff"), @res)

    assert_equal "stuff", response.success.to_hash[:name]
  end

  it "responds with 404 when not found" do
    endpoint = Zuul::Endpoint::RepositoryLookup.new(EmptyRepositoryFinder.new)
    response = endpoint.get(Zuul::Test::Request.new(:slug => "some%2Fstuff"), @res)

    assert_equal 404, response.failure.status
    assert_equal "not_found_error", response.failure.type
  end
end
