require 'test_helper'

describe Issues::Milestone do
  fixtures :users, :projects

  describe 'validations' do
    it 'has errors when name is blank' do
      milestone = Issues::Milestone.create(:name => '')

      milestone.errors[:name].must_include("can't be blank")
      milestone.persisted?.must_equal(false)
    end

    it 'has errors when project is blank' do
      milestone = Issues::Milestone.create(:project_id => nil)

      milestone.errors[:project].must_include("can't be blank")
      milestone.persisted?.must_equal(false)
    end
  end

  describe '#create' do
    let(:project) { projects(:johans) }

    it 'persists label when it has valid attributes' do
      milestone = Issues::Milestone.create(
        :name  => 'Version 1.0',
        :project => project
      )

      milestone.persisted?.must_equal(true)
    end
  end
end
