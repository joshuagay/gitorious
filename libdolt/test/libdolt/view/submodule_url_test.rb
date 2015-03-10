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

module Dolt
  module View
    class SubmoduleUrlTest < MiniTest::Spec
      describe SubmoduleUrl do
        it "recognizes urls from gitorious.org" do
          submodule = { :url => "http://git.gitorious.org/bar/baz.git", :oid => "sha123" }

          assert_equal "https://gitorious.org/bar/baz/source/sha123", SubmoduleUrl.for(submodule)
        end

        it "recognizes urls from bitbucket.org" do
          submodule = { :url => "https://bitbucket.org/bar/baz.git", :oid => "sha123" }

          assert_equal "https://bitbucket.org/bar/baz/src/sha123", SubmoduleUrl.for(submodule)
        end

        it "recognizes urls from github.com" do
          submodule = { :url => "git://github.com/bar/baz.git", :oid => "sha123" }

          assert_equal "https://github.com/bar/baz/tree/sha123", SubmoduleUrl.for(submodule)
        end

        it "returns other urls unchanged" do
          submodule = { :url => "git://foobar.com/bar/baz.git", :oid => "sha123" }

          assert_equal "git://foobar.com/bar/baz.git", SubmoduleUrl.for(submodule)
        end
      end

      describe SubmoduleUrl::GitoriousOrg do
        let(:parser) { SubmoduleUrl::GitoriousOrg.new }
        let(:expected_url) { "https://gitorious.org/foo/bar/source/sha123" }

        describe "ssh urls" do
          it "returns nil for other users" do
            assert_nil parser.browse_url("foo@gitorious.org:foo/bar.git", "sha123")
          end

          it "returns nil for other domains" do
            assert_nil parser.browse_url("git@github.com:foo/bar.git", "sha123")
          end

          it "returns repository url for matching protocol and domain" do
            assert_equal expected_url, parser.browse_url("git@gitorious.org:foo/bar.git", "sha123")
          end
        end

        describe "https urls" do
          it "returns nil for other domains" do
            assert_nil parser.browse_url("http://git.github.com/foo/bar.git", "sha123")
          end

          it "returns repository url for matching protocol and domain" do
            assert_equal expected_url, parser.browse_url("http://git.gitorious.org/foo/bar.git", "sha123")
          end
        end

        describe "git urls" do
          it "returns nil for other domains" do
            assert_nil parser.browse_url("git://github.com/foo/bar.git", "sha123")
          end

          it "returns repository url for matching protocol and domain" do
            assert_equal expected_url, parser.browse_url("git://gitorious.org/foo/bar.git", "sha123")
          end
        end

        describe "legacy urls" do
          it "returns repository url for legacy git url" do
            assert_equal expected_url, parser.browse_url("git://gitorious.org/~baz/foo/bar.git", "sha123")
          end

          it "returns repository url for legacy http url" do
            assert_equal expected_url, parser.browse_url("http://git.gitorious.org/~baz/foo/bar.git", "sha123")
          end

          it "returns repository url for legacy ssh url" do
            assert_equal expected_url, parser.browse_url("git@gitorious.org:+baz/foo/bar.git", "sha123")
          end
        end
      end
    end
  end
end
