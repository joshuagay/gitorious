require 'test_helper'

class PostStatusUpdateTest < ActionDispatch::IntegrationTest
  def setup
    Status.create!(:title => "YESSIR", :status => Status::OK)
    User.create!(:login => "joe", :password => "joe")
  end

  test "Posting a status update" do
    new_session do | gitorian |
      gitorian.logs_in_successfully_as("joe", "joe")
      gitorian.creates_status_update("All OK")
      gitorian.visits_home_page_and_sees_his_update("All OK")
    end
  end

  test "Unauthorized user trying to post status update" do
    new_session do |hacker|
      hacker.logs_in_unsuccessfully_as("hacker", "joe")
      hacker.creates_status_update("All messed up")
      hacker.visits_home_page_and_does_not_see_his_update("All messed up")
    end
  end

  def new_session
    open_session do |session|
      session.extend(TestDSL)
      yield session
    end
  end

  module TestDSL
    def logs_in_as(username, password)
      get new_session_path

      assert_response :success
      post sessions_path, {:login => username, :password => password}
    end

    def logs_in_successfully_as(username, password)
      logs_in_as(username, password)

      assert_redirected_to new_status_path
    end

    def logs_in_unsuccessfully_as(username, password)
      logs_in_as(username, password)

      assert_response :success
    end

    def creates_status_update(message)
      post statuses_path, :status => {:title => message, :body => "...", :status => Status::OK}
    end

    def visits_home_page_and_sees_his_update(message)
      get root_path

      assert_select "h1", message
    end

    def visits_home_page_and_does_not_see_his_update(message)
      get root_path

      assert_select "h1", {:text => message, :count => 0}
    end
  end
end
