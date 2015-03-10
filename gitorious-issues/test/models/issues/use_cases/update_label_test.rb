require 'test_helper'

describe Issues::Issue do
  fixtures 'users', 'projects', 'issues/labels'

  describe '.call' do
    it 'update existing label' do
      label = issues_labels(:bug)
      params = { :name => 'big bug', :color => 'deep red' }
      Issues::UseCases::UpdateLabel.call(:label => label, :params => params)

      label.reload

      assert label.persisted?
      assert_equal 'big bug', label.name
      assert_equal 'deep red', label.color
    end
  end
end
