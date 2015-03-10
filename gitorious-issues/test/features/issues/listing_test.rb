require "test_helper"

feature 'Project Issues Tab' do
  fixtures 'issues/issues',  'issues/labels', 'issues/issue_labels'

  let(:user)    { Features::User.new(users(:johan), self) }
  let(:project) { projects(:johans) }
  let(:routes)  { Issues::Engine.routes.url_helpers }

  scenario 'visting project issues page as a project admin', :js => true do
    user.sign_in

    visit routes.project_issues_path(project)

    assert_content page, project.title
    assert_content page, 'issue #1'
    assert_content page, 'issue #2'
    refute_content page, 'issue #3'
    refute_content page, 'issue #4'

    user.open_pull_box('issue-filters')
    user.check_filter('bug')
    user.filter_issues

    assert page.has_content?('issue #1')
    refute page.has_content?('issue #2')
    refute page.has_content?('issue #3')

    user.uncheck_filter('bug')
    user.check_filter('Resolved')
    user.filter_issues

    refute_content page, 'issue #1'
    refute_content page, 'issue #2'
    refute_content page, 'issue #3'
    assert_content page, 'issue #4'

    user.uncheck_filter('Resolved')
    user.check_filter('High')
    user.filter_issues

    refute_content page, 'issue #1'
    assert_content page, 'issue #2'
    refute_content page, 'issue #3'
    refute_content page, 'issue #4'
  end

  scenario 'deleting an issue', :js => true do
    user.sign_in

    visit routes.project_issues_path(project)

    page.execute_script('$(".gts-project-issues .gts-issue:first-child .dropdown-toggle").click()')
    click_on 'Delete'

    assert page.has_content?('Issue was deleted')
    refute page.has_content?('issue #3')
  end

  scenario 'visiting project issues page as a normal user' do
    visit routes.project_issues_path(project)

    refute page.has_content?('Manage milestones')
    refute page.has_content?('Manage labels')
  end
end
