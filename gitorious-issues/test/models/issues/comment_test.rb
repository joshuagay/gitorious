require 'test_helper'

describe Issues::Comment do
  fixtures :users, :projects, 'issues/issues'

  describe 'validations' do
    it 'has errors when issue is blank' do
      comment = Issues::Comment.create(:issue_id => nil)

      comment.errors[:issue].must_include("can't be blank")
      comment.persisted?.must_equal(false)
    end

    it 'has errors when user is blank' do
      comment = Issues::Comment.create(:user_id => nil)

      comment.errors[:user].must_include("can't be blank")
      comment.persisted?.must_equal(false)
    end

    it 'has errors when body is blank' do
      comment = Issues::Comment.create(:body => '')

      comment.errors[:body].must_include("can't be blank")
      comment.persisted?.must_equal(false)
    end
  end

  describe '#create' do
    let(:user)    { users(:johan) }
    let(:project) { projects(:johans) }
    let(:issue)   { issues_issues(:one) }

    it 'persists comment when it has valid attributes' do
      comment = Issues::Comment.create(
        :user => user,
        :issue => issue,
        :body => 'test comment'
      )

      comment.persisted?.must_equal(true)
    end
  end
end
