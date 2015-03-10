require "test_helper"

feature 'Project Issues Tab' do
  fixtures 'issues/issues'

  let(:user)    { Features::User.new(users(:johan), self) }
  let(:project) { projects(:johans) }
  let(:routes)  { Issues::Engine.routes.url_helpers }

  scenario 'updating an issue', :js => true do
    user.sign_in

    visit routes.project_issues_path(project)

    click_on 'issue #1'

    page.must_have_content('issue #1')
    page.must_have_content('this is issue number one')

    click_on 'Edit'

    find('#issue_title').set('issue number one')

    within('.issue-assignee-widget') do
      find('#issue_assignee_candidate').set('johan')
      click_on 'Assign'
    end

    within('.issue-label-widget') do
      find('#issue_label').set('task')
      click_on 'Add'
    end

    click_on 'Save'

    page.must_have_content('Issue updated successfuly')
    page.must_have_content('issue number one')

    click_on 'issue number one'

    within('.issue-assignees') do
      page.must_have_content 'johan'
    end

    within('.issue-labels') do
      page.must_have_content 'task'
    end
  end
end
