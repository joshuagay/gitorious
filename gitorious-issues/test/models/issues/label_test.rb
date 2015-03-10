require 'test_helper'

describe Issues::Label do
  fixtures :users, :projects

  describe 'validations' do
    it 'has errors when name is blank' do
      issue = Issues::Label.create(:name => '')

      issue.errors[:name].must_include("can't be blank")
      issue.persisted?.must_equal(false)
    end

    it 'has errors when color is blank' do
      issue = Issues::Label.create(:color => '')

      issue.errors[:color].must_include("can't be blank")
      issue.persisted?.must_equal(false)
    end

    it 'has errors when project is blank' do
      issue = Issues::Label.create(:project_id => nil)

      issue.errors[:project].must_include("can't be blank")
      issue.persisted?.must_equal(false)
    end
  end

  describe '#create' do
    let(:project) { projects(:johans) }

    it 'persists label when it has valid attributes' do
      issue = Issues::Label.create(
        :color => '#000',
        :name  => 'darkness',
        :project => project
      )

      issue.persisted?.must_equal(true)
    end
  end
end
