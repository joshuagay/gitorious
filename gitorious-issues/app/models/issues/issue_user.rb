class Issues::IssueUser < ActiveRecord::Base
  attr_accessible :id, :issue_id, :user_id

  belongs_to :issue
  belongs_to :user
end
