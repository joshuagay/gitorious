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
require "zuul/serializer/team"
require "ostruct"

describe Zuul::Serializer::Team do
  before do
    @created = Time.now
    @team = OpenStruct.new({
        :id => 1,
        :name => "gitorians"
      })
  end

  it "proxies id" do
    serializer = Zuul::Serializer::Team.new(@team)
    assert_equal 1, serializer.id
  end

  it "serializes team as hash" do
    serializer = Zuul::Serializer::Team.new(@team)
    assert_equal({ :id => 1, :name => "gitorians" }, serializer.to_hash)
  end
end
