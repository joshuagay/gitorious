require 'test_helper'

describe Issues::Issue do
  fixtures 'users', 'projects', 'issues/issues', 'issues/labels'

  let(:user)    { users(:johan) }
  let(:project) { projects(:johans) }
  let(:label)   { issues_labels(:task) }

  describe '.call' do
    def params(num)
      {
        :title => "issue ##{num}",
        :priority => num,
        :assignee_ids => [user.id],
        :label_ids => [label.id]
      }
    end

    it 'persists a new issue' do
      Issues::Issue.delete_all

      issue1 = Issues::UseCases::CreateIssue.call(
        :user => user, :project => project, :params => params(1)
      )

      issue2 = Issues::UseCases::CreateIssue.call(
        :user => user, :project => project, :params => params(2)
      )

      assert issue1.persisted?
      assert_equal 'issue #1', issue1.title
      assert_equal user, issue1.user
      assert_equal project, issue1.project
      assert issue1.assignees.include?(user)
      assert issue1.labels.include?(label)
      assert_equal 1, issue1.priority
      assert_equal 1, issue1.issue_id

      assert issue2.persisted?
      assert_equal 'issue #2', issue2.title
      assert_equal user, issue2.user
      assert_equal project, issue2.project
      assert issue2.assignees.include?(user)
      assert issue2.labels.include?(label)
      assert_equal 2, issue2.priority
      assert_equal 2, issue2.issue_id
    end
  end
end
