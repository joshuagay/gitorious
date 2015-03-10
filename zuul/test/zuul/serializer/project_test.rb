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
require "zuul/serializer/project"
require "ostruct"

describe Zuul::Serializer::Project do
  before do
    owner = OpenStruct.new(:id => 13)
    @created = Time.now
    @project = OpenStruct.new(:id => 42, :owner => owner,
                              :title => "Project", :description => "Desc",
                              :slug => "project", :created_at => @created,
                              :wiki_repository => nil)
  end

  it "proxies id" do
    serializer = Zuul::Serializer::Project.new(@project)
    assert_equal 42, serializer.id
  end

  it "generates url" do
    serializer = Zuul::Serializer::Project.new(@project)
    assert_equal "/projects/42", serializer.url
  end

  it "generates hash" do
    serializer = Zuul::Serializer::Project.new(@project)
    expected = {
      :id => 42,
      :description => "Desc",
      :title => "Project",
      :slug => "project",
      :created_at => @created,
      :owner => { :id => 13, :type => "OpenStruct" }
    }
    assert_equal expected, serializer.to_hash
  end

  it "includes wiki URL" do
    def @project.wiki_repository;
      OpenStruct.new(:default_clone_url => "git://gts/project/wiki.git")
    end

    serializer = Zuul::Serializer::Project.new(@project)

    assert_equal "git://gts/project/wiki.git", serializer.to_hash["wiki_url"]
  end
end
