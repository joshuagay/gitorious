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
require "zuul/serializer/user"
require "ostruct"

describe Zuul::Serializer::User do
  before do
    @user = OpenStruct.new(:id => 1,
                           :login => "mm",
                           :fullname => "Mega Man",
                           :email => "mm@capcom.com")
  end

  it "proxies id" do
    serializer = Zuul::Serializer::User.new(@user)
    assert_equal 1, serializer.id
  end

  it "serializes user as hash" do
    def @user.public_email?; false; end
    serializer = Zuul::Serializer::User.new(@user)

    expected = { :id => 1, :login => "mm", :name => "Mega Man" }
    assert_equal expected, serializer.to_hash
  end

  it "serializes user with public email" do
    def @user.public_email?; true; end
    serializer = Zuul::Serializer::User.new(@user)

    assert_equal({ :id => 1,
                   :login => "mm",
                   :name => "Mega Man",
                   :email => "mm@capcom.com"

            }, serializer.to_hash)
  end
end
