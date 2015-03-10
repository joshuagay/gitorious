require 'test_helper'

describe Issues::Issue do
  fixtures 'users', 'projects', 'issues/issues', 'issues/labels'

  let(:issue) { issues_issues('one') }

  describe '.call' do
    it 'update existing issue' do
      params = { :title => 'other', :priority => 4 }
      Issues::UseCases::UpdateIssue.call(:issue => issue, :params => params)

      issue.reload

      assert issue.persisted?
      assert_equal 'other', issue.title
      assert_equal 4, issue.priority
    end
  end
end
