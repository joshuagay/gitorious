class Issues::IssueLabel < ActiveRecord::Base
  attr_accessible :issue_id, :label_id

  belongs_to :issue
  belongs_to :label
end
