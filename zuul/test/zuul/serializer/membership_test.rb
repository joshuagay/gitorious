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
require "zuul/serializer/membership"
require "ostruct"

describe Zuul::Serializer::Membership do
  before do
    @membership = OpenStruct.new({
        :id => 1,
        :user => OpenStruct.new(:login => "christian"),
        :group => OpenStruct.new(:id => 42, :name => "gitorians"),
        :role => OpenStruct.new(:name => "Administrator")
      })
  end

  it "proxies id" do
    serializer = Zuul::Serializer::Membership.new(@membership)
    assert_equal 1, serializer.id
  end

  it "serializes membership as hash" do
    serializer = Zuul::Serializer::Membership.new(@membership)

    expected = {
      :id => 1,
      :user => { :login => "christian" },
      :group => { :name => "gitorians" },
      :role => "administrator"
    }

    assert_equal expected, serializer.to_hash
  end

  it "generates url" do
    serializer = Zuul::Serializer::Membership.new(@membership)
    assert_equal "/teams/42/memberships/1", serializer.url
  end
end
