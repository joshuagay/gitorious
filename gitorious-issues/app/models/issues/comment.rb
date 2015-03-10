class Issues::Comment < ActiveRecord::Base
  attr_accessible :body, :id, :issue_id, :user_id, :issue, :user

  belongs_to :user
  belongs_to :issue

  validates :issue, :user, :body, :presence => true
end
