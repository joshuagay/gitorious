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
require "zuul/hash_router"

describe Zuul::HashRouter do
  before do
    @router = Zuul::HashRouter.new
  end

  it "routes OPTION requests" do
    @router.options("/something")
    expected = { :options => { "/something" => { :method => :options } } }
    assert_equal(expected, @router.routes)
  end

  it "routes OPTION request to custom method" do
    @router.options("/something", :mymethod)
    expected = { :options => { "/something" => { :method => :mymethod } } }
    assert_equal(expected, @router.routes)
  end

  it "routes GET requests" do
    @router.get("/something")
    expected = { :get => { "/something" => { :method => :get } } }
    assert_equal(expected, @router.routes)
  end

  it "routes POST requests" do
    @router.post("/something")
    expected = { :post => { "/something" => { :method => :post } } }
    assert_equal(expected, @router.routes)
  end

  it "routes HEAD requests" do
    @router.head("/something")
    expected = { :head => { "/something" => { :method => :head } } }
    assert_equal(expected, @router.routes)
  end

  it "routes DELETE requests" do
    @router.delete("/something")
    expected = { :delete => { "/something" => { :method => :delete } } }
    assert_equal(expected, @router.routes)
  end
end
