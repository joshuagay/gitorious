require 'test_helper'

describe Issues::Query do
  fixtures :users, :projects

  describe 'validations' do
    it 'has errors when user is blank' do
      comment = Issues::Query.create(:user_id => nil)

      comment.errors[:user].must_include("can't be blank")
      comment.persisted?.must_equal(false)
    end

    it 'has errors when project is blank' do
      comment = Issues::Query.create(:project_id => nil)

      comment.errors[:project].must_include("can't be blank")
      comment.persisted?.must_equal(false)
    end

    it 'has errors when name is blank' do
      comment = Issues::Query.create(:name => '')

      comment.errors[:name].must_include("can't be blank")
      comment.persisted?.must_equal(false)
    end

    it 'has errors when data is blank' do
      comment = Issues::Query.create(:data => '')

      comment.errors[:data].must_include("can't be blank")
      comment.persisted?.must_equal(false)
    end
  end

  describe '#create' do
    let(:user)    { users(:johan) }
    let(:project) { projects(:johans) }

    it 'persists query when it has valid attributes' do
      comment = Issues::Query.create(
        :user => user,
        :project => project,
        :name => 'some query',
        :data => '{}'
      )

      comment.persisted?.must_equal(true)
    end
  end
end
