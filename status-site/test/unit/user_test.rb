require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.create! :login => "bill", :password => "bob"
  end
  
  context "Authentication" do
    should "authenticate user" do
      assert_equal @user, User.authenticate(@user.login, "bob")
    end
  end

  should validate_uniqueness_of :login

  context "creating users" do
    should "encrypt password for security" do
      user = User.create! :login => "Leland", :password => "Palmer"

      assert_not_equal "Palmer", user.password
    end
  end
end
