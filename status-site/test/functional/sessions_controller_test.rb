require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  context "Successful login" do
    setup do
      @user = User.create! :login => "bill", :password => "bob"
    end
    
    should "log in existing user" do
      post :create, {:login => @user.login, :password => "bob"}

      assert_response :redirect
      assert_equal @user.id, session[:current_user_id]
    end
  end

  context "Failed login" do
    should "not log in with invalid username/password combo" do
      post :create, :login => "bill", :password => "sikret"

      assert_response :success
      assert_nil session[:current_user_id]
    end
  end

end
