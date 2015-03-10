require 'test_helper'

describe Issues::Issue do
  fixtures :users, :projects

  describe 'validations' do
    it 'has errors when title is blank' do
      issue = Issues::Issue.create(:title => '')

      issue.errors[:title].must_include("can't be blank")
      issue.persisted?.must_equal(false)
    end

    it 'has errors when user is blank' do
      issue = Issues::Issue.create(:user_id => nil)

      issue.errors[:user].must_include("can't be blank")
      issue.persisted?.must_equal(false)
    end

    it 'has errors when project is blank' do
      issue = Issues::Issue.create(:project_id => nil)

      issue.errors[:project].must_include("can't be blank")
      issue.persisted?.must_equal(false)
    end
  end

  describe 'assignee_candidates' do
    it 'returns committers of a project without assignees' do
      project = Project.new
      issue = Issues::Issue.new(project: project)
      johan = User.new(fullname: 'johan')
      mike = User.new(fullname: 'mike')
      issue.assignees << johan
      issue.project.stubs(:members).returns([johan, mike])

      issue.assignee_candidates.must_equal([mike])
    end
  end

  describe '#create' do
    let(:user)    { users(:johan) }
    let(:project) { projects(:johans) }

    it 'persists issue when it has valid attributes' do
      issue = Issues::Issue.create(
        :title => 'test issue',
        :project => project,
        :state => 'new',
        :user => user
      )

      issue.persisted?.must_equal(true)
      issue.state.must_equal('new')
    end
  end
end
