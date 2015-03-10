class Status < ActiveRecord::Base
  OK = 1
  SORTA = 2
  DOWN = 3
  @@statuses = [OK, SORTA, DOWN]
  validates_presence_of :title, :status
  scope :problems, { :conditions => ["status in (2, 3)"], :order => "created_at desc" }

  attr_accessor :post_to_twitter

  def status=(code)
    code = code.to_i
    return self[:status] = code if @@statuses.include?(code)
    false
  end

  def status_text
    Status.status_text(status)
  end

  def self.current
    status = last
    raise ActiveRecord::RecordNotFound.new if status.nil?
    status
  end

  def self.last_problem
    problems.find(:first)
  end

  def self.status_text(status)
    status == OK && "Ok" || status == SORTA && "Sorta" || status == DOWN && "Down" || ""
  end

  def self.statuses
    @@statuses
  end

  @@statuses.each do |stat|
    define_method(:"#{Status.status_text(stat).downcase}?") { status == stat }
  end
end
