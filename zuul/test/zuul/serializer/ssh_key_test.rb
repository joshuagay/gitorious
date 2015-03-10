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
require "zuul/serializer/ssh_key"
require "ostruct"

describe Zuul::Serializer::SshKey do
  before do
    user = OpenStruct.new(:id => 13)
    @key = OpenStruct.new(:id => 42, :user => user,
                          :key => "key", :comment => "Comment")
  end

  it "proxies id" do
    serializer = Zuul::Serializer::SshKey.new(@key)
    assert_equal 42, serializer.id
  end

  it "generates url" do
    serializer = Zuul::Serializer::SshKey.new(@key)
    assert_equal "/users/13/ssh_keys", serializer.url
  end

  it "generates hash" do
    serializer = Zuul::Serializer::SshKey.new(@key)
    expected = { :id => 42, :comment => "Comment", :key => "key" }
    assert_equal expected, serializer.to_hash
  end
end
