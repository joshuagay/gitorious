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
require "zuul/serializer/repository"
require "ostruct"

class User
  attr_reader :id
  def initialize(id); @id = id; end
end

describe Zuul::Serializer::Repository do
  before do
    @created = Time.now
    @repository = OpenStruct.new({
        :id => 1,
        :name => "mainline",
        :description => "A cool repo",
        :created_at => @created,
        :owner => User.new(42),
        :project => OpenStruct.new(:id => 13)
      })
  end

  it "proxies id" do
    serializer = Zuul::Serializer::Repository.new(@repository)
    assert_equal 1, serializer.id
  end

  it "serializes repository as hash" do
    serializer = Zuul::Serializer::Repository.new(@repository)

    expected = {
      :id => 1,
      :name => "mainline",
      :description => "A cool repo",
      :created_at => @created,
      :owner => {
        :id => 42,
        :type => "User"
      }
    }

    assert_equal expected, serializer.to_hash
  end

  it "generates url" do
    serializer = Zuul::Serializer::Repository.new(@repository)
    assert_equal "/projects/13/repositories/1", serializer.url
  end
end
