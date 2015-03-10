# encoding: utf-8
# --
# The MIT License (MIT)
#
# Copyright (C) 2012 Gitorious AS
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#++
require "test_helper"
require "tiltout"

module ViewHelper
  def say_it; "YES"; end
end

describe Tiltout do
  before do
    @root = "/dolt/views"
    File.stubs(:exists?).returns(false)
  end

  def file_read
    File.respond_to?(:binread) ? :binread : :read
  end

  def fake_file(file, content)
    File.stubs(:exists?).with(file).returns(true)
    File.stubs(file_read).with(file).returns(content)
  end

  it "reads template from file" do
    fake_file("/dolt/views/file.erb", "")
    renderer = Tiltout.new("/dolt/views")
    renderer.render(:file)
  end

  it "renders template with locals" do
    fake_file("#{@root}/file.erb", <<-ERB)
<%= name %>!
    ERB
    renderer = Tiltout.new(@root)

    assert_equal "Chris!\n", renderer.render(:file, { :name => "Chris"})
  end

  it "caches template in memory" do
    renderer = Tiltout.new(@root)
    fake_file("#{@root}/file.erb", "Original")
    renderer.render(:file)
    fake_file("#{@root}/file.erb", "Updated")

    assert_equal "Original", renderer.render(:file)
  end

  it "does not cache template in memory when configured not to" do
    renderer = Tiltout.new(@root, :cache => false)
    fake_file("#{@root}/file.erb", "Original")
    renderer.render(:file)
    fake_file("#{@root}/file.erb", "Updated")

    assert_equal "Updated", renderer.render(:file)
  end

  it "renders template with layout" do
    renderer = Tiltout.new("/", :layout => "layout")
    fake_file("/file.erb", "Template")
    fake_file("/layout.erb", <<-ERB)
I give you: <%= yield %>
    ERB

    assert_equal "I give you: Template\n", renderer.render(:file)
  end

  it "renders template not in template root" do
    renderer = Tiltout.new("/else")
    fake_file("/somewhere/file.erb", "Template")
    fake_file("/my/layout.erb", <<-ERB)
I give you: <%= yield %>
    ERB

    template = { :file => "/somewhere/file.erb" }
    assert_equal "Template", renderer.render(template)
  end

  it "renders template with layout not in template root" do
    renderer = Tiltout.new("/somewhere", :layout => { :file => "/my/layout.erb" })
    fake_file("/somewhere/file.erb", "Template")
    fake_file("/my/layout.erb", <<-ERB)
I give you: <%= yield %>
    ERB

    assert_equal "I give you: Template\n", renderer.render(:file)
  end

  it "renders template once without layout" do
    renderer = Tiltout.new("/", :layout => "layout")
    fake_file("/file.erb", "Template")
    fake_file("/layout.erb", <<-ERB)
I give you: <%= yield %>
    ERB

    assert_equal "Template", renderer.render(:file, {}, :layout => nil)
  end

  it "renders template once with different layout" do
    renderer = Tiltout.new("/", :layout => "layout")
    fake_file("/file.erb", "Template")
    fake_file("/layout.erb", <<-ERB)
I give you: <%= yield %>
    ERB
    fake_file("/layout2.erb", <<-ERB)
I present you: <%= yield %>
    ERB

    html = renderer.render(:file, {}, :layout => "layout2")

    assert_equal "I present you: Template\n", html
  end

  it "renders templates of default type" do
    renderer = Tiltout.new("/", :default_type => :str)
    fake_file("/file.str", "Hey!")

    assert_equal "Hey!", renderer.render(:file)
  end

  it "renders templates of specific type" do
    renderer = Tiltout.new("/", :default_type => :lol)
    fake_file("/file.lol", "No!")
    fake_file("/file.erb", "Yes!")
    File.stubs(:exists?).with("/file.lol").returns(false)
    File.stubs(:exists?).with("/file.erb").returns(true)

    assert_equal "Yes!", renderer.render("file.erb")
  end

  it "renders with helper object" do
    renderer = Tiltout.new("/")
    renderer.helper(ViewHelper)
    fake_file("/file.erb", <<-ERB)
Say it: <%= say_it %>
    ERB

    assert_equal "Say it: YES\n", renderer.render(:file)
  end

  it "creates with helper object" do
    renderer = Tiltout.new("/", :helpers => [ViewHelper])
    fake_file("/file.erb", <<-ERB)
Say it: <%= say_it %>
    ERB

    assert_equal "Say it: YES\n", renderer.render(:file)
  end

  it "uses hash as helper" do
    renderer = Tiltout.new("/")
    renderer.helper(:say_it => 42, "do_it" => 12)
    fake_file("/file.erb", <<-ERB)
Say it: <%= say_it %>, <%= do_it %>
    ERB

    assert_equal "Say it: 42, 12\n", renderer.render(:file)
  end

  it "does not leak state across render calls" do
    renderer = Tiltout.new("/")
    fake_file("/file.erb", <<-TEMPLATE)
<%= @response %><% @response = "NO" %><%= @response %>
    TEMPLATE

    assert_equal "NO", renderer.render(:file)
    assert_equal "NO", renderer.render(:file)
  end

  it "shares state between template and layout" do
    renderer = Tiltout.new("/", :layout => "layout")
    fake_file("/file.erb", <<-TEMPLATE)
<h1><%= @response %><% @response = "NO" %><%= @response %></h1>
    TEMPLATE
    fake_file("/layout.erb", "<title><%= @response %></title><%= yield %>")

    assert_equal "<title>NO</title><h1>NO</h1>\n", renderer.render(:file)
  end

  describe "partials" do
    it "renders partial" do
      renderer = Tiltout.new("/", :helpers => [Tiltout::Partials])
      fake_file("/part.erb", "I'm partial")
      fake_file("/file.erb", <<-TEMPLATE)
<%= partial(:part) %>!
      TEMPLATE

      assert_equal "I'm partial!\n", renderer.render(:file)
    end

    it "renders partial in template context" do
      renderer = Tiltout.new("/", :helpers => [Tiltout::Partials])
      fake_file("/part.erb", <<-ERB)
<%= @name %> is partial
      ERB
      fake_file("/file.erb", <<-TEMPLATE)
<% @name = "Chris" %>
<%= partial(:part) %>
      TEMPLATE

      assert_equal "Chris is partial\n", renderer.render(:file)
    end
  end

  describe "multiple view paths" do
    it "uses the first available template" do
      fake_file("/dolt/views/file.erb", "#1")
      fake_file("/tlod/views/file.erb", "#2")
      renderer = Tiltout.new(["/dolt/views", "/tlod/views"])

      assert_equal "#1", renderer.render(:file)
    end

    it "uses only available template" do
      fake_file("/tlod/views/file.erb", "#2")
      renderer = Tiltout.new(["/dolt/views", "/tlod/views"])

      assert_equal "#2", renderer.render(:file)
    end
  end
end
