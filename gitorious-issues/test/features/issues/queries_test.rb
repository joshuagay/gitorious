require "test_helper"

feature 'Project Issues Tab' do
  let(:user)    { Features::User.new(users(:johan), self) }
  let(:project) { projects(:johans) }
  let(:routes)  { Issues::Engine.routes.url_helpers }

  background do
    user.sign_in

    Issues::Issue.destroy_all

    labels = %w(bug feature task)

    3.times { |i| user.create_issue(:title => "issue ##{i+1}", :labels => [labels[i]]) }
  end

  scenario 'saving a custom query', :js => true do
    visit routes.project_issues_path(project)

    user.open_pull_box('issue-filters')
    user.check_filter('feature')
    user.filter_issues

    click_on 'Save this query'

    within('#new_query') do
      find('#query_name').set('features')
      click_on 'Save'
    end

    page.must_have_content 'Custom query was saved'

    within('#private-issue-queries') do
      click_on 'features'
    end

    assert page.has_content?('issue #2')
    refute page.has_content?('issue #1')
    refute page.has_content?('issue #3')
  end
end
