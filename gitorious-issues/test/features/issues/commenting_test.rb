require "test_helper"

feature 'Project Issues Tab' do
  let(:user)    { Features::User.new(users(:johan), self) }
  let(:project) { projects(:johans) }
  let(:routes)  { Issues::Engine.routes.url_helpers }

  scenario 'visting project issues page as a project admin', :js => true do
    user.sign_in

    visit routes.project_issues_path(project)

    click_on 'issue #1'

    find('#comment_body').set('oh hai')
    click_on('Save')

    page.must_have_content 'Comment added successfuly'
    page.must_have_content 'oh hai'

    within(".gts-comment-list") do
      click_on 'Edit'
    end

    find('#comment_body').set('oh hai again')
    click_on 'Save'

    page.must_have_content 'Your comment was updated'
    page.must_have_content 'oh hai again'
  end
end
