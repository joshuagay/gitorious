class Issues::Milestone < ActiveRecord::Base
  attr_accessible :name, :description,:due_date, :project_id, :project

  belongs_to :project
  has_many :issues, :dependent => :nullify

  validates :name, :project, :presence => true

  def self.sorted
    order('name ASC')
  end
end
