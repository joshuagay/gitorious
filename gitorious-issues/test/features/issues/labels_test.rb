require "test_helper"

feature 'Project Issues Tab' do
  fixtures 'issues/labels'

  let(:user)    { Features::User.new(users(:johan), self) }
  let(:project) { projects(:johans) }
  let(:routes)  { Issues::Engine.routes.url_helpers }

  background do
    user.sign_in
  end

  scenario 'creating a new label', :js => true do
    user.create_label(:name => 'question')

    within('.gts-project-issue-labels') do
      assert page.has_content?('question')
    end
  end

  scenario 'deleting a label', :js => true do
    visit routes.project_issues_path(project)

    page.execute_script("$('.gts-issues-settings-dropdown').click()")
    click_on 'Manage labels'

    within('.gts-project-issue-labels tbody tr:first-child') do
      click_on 'Delete'
      sleep 0.5
      refute page.has_content?('bug')
    end
  end
end
