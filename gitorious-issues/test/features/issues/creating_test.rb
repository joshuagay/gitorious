require "test_helper"

feature 'Project Issues Tab' do
  let(:user)    { Features::User.new(users(:johan), self) }
  let(:project) { projects(:johans) }
  let(:routes)  { Issues::Engine.routes.url_helpers }

  scenario 'creating an issue', :js => true do
    Issues::Issue.destroy_all

    user.sign_in

    visit routes.new_project_issue_path(project)

    user.create_issue(:title => 'issue #1', :labels => %w(bug))
    user.create_issue(:title => 'issue #2')
    user.create_issue(:title => 'issue #3')

    assert page.has_content?('issue #1')
    assert page.has_content?('issue #2')
    assert page.has_content?('issue #3')

    click_on 'issue #1'

    page.must_have_content('issue #1')
    page.must_have_content('test issue')
  end
end
