class Issues::Query < ActiveRecord::Base
  attr_accessible :name, :data, :public, :project_id, :project, :user_id, :user

  belongs_to :user
  belongs_to :project

  validates :name, :data, :project, :user, :presence => true

  def self.sorted
    order('name ASC')
  end

  def self.public
    where(:public => true)
  end

  def self.private
    where(:public => false)
  end
end
