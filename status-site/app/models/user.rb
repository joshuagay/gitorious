require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  validates_uniqueness_of :login
  
  def self.authenticate(login, password)
    user = find(:first, :conditions => {:login => login})
    !user.nil? && user.password == password ? user : nil
  end

  def password
    @password ||= Password.new(self[:password])
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self[:password] = @password
  end
end
