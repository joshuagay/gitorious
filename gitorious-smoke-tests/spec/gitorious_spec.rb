require 'spec_helper'

feature 'Gitorious' do

  scenario 'Logging in, creating project & repository, pushing and pulling' do
    name = gen_name
    key = KeyPair.generate

    login_page.login

    keys_page.upload_public_key(key)

    origin = project_page.create_repository(name)

    git = Git.new(name, origin, key)
    git.clone
    git.configure_user
    git.add_file(foo: 'a new file')
    git.push

    repository_page.open(name)
    repository_page.should_include_file('foo')

    head_sha = git.head_sha

    repository_page.clone_urls.each do |protocol, url|
      git = Git.new("#{name}-#{protocol}", url, key)
      git.clone
      git.head_sha.should == head_sha
    end
  end

  scenario "Asset loading" do
    home_page.open

    home_page.should_include_valid_css_urls
    home_page.should_include_valid_js_urls
  end

  scenario "Searching" do
    login_page.login

    search_page.open("żółć")

    search_page.should_include_results_for("żółć")
  end

end
