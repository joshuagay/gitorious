class Issues::Label < ActiveRecord::Base
  attr_accessible :color, :name, :project_id, :project

  belongs_to :project

  has_many :issue_labels, :dependent => :destroy
  has_many :issues, :through => :issue_labels

  validates :name, :color, :project, :presence => true

  def self.sorted
    order('name ASC')
  end
end
