require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  context "Displaying status" do
    setup do
      @status = Status.create :title => "OK", :body => "All systems go", :status => Status::OK
    end
    
    should "find status by ID" do
      get :show, :id => @status
      
      assert_response :success
      assert_equal @status, assigns(:status)
    end
  end

  context "Creating a status update" do
    setup do
      login_as(User.create({ :login => "bob", :password => "mike" }))
    end

    should "render the status form" do
      get :new
      
      assert_response :success
      assert_not_nil assigns(:status)
    end

     should "create a valid status" do
      assert_difference("Status.count", 1) do
        create_valid_status
      end
    end

    should "redirect after create" do
      create_valid_status

      assert_response :redirect
      assert_redirected_to :action => :show, :id => Status.last
    end

    should "not accept invalid statuses" do
      assert_no_difference("Status.count") do
        post :create, :status => {:title => "All OK", :body => "Yeah"}
      end
    end
  end

  context "Update Twitter" do
    setup do
      login_as(User.create({:login => "bob", :password => "mule"}))
    end

    should "not connect to Twitter if environment vars aren't set" do
      @controller.expects(:post_to_twitter)
      post :create, :status => {:title => "All OK", :body => "Yeah", :post_to_twitter => "1"}
    end

    should "send to Twitter if environment vars are set" do
      client = stub
      client.expects(:update).with("[UP] OK: Yeah")
      token = "abc"
      secret = "def"
      consumer_key = "001"
      consumer_secret = "002"
      Twitter::Client.expects(:new).with(
                                         :oauth_token => token,
                                         :oauth_token_secret => secret,
                                         :consumer_key => consumer_key,
                                         :consumer_secret => consumer_secret).returns(client)
      ENV["TWITTER_OAUTH_KEY"] = token
      ENV["TWITTER_OAUTH_SECRET"] = secret
      ENV["TWITTER_CONSUMER_KEY"] = consumer_key
      ENV["TWITTER_CONSUMER_SECRET"] = consumer_secret
      post :create, :status => {:title => "OK", :body => "Yeah", :post_to_twitter => "1", :status => Status::OK}
    end
  end

  context "Updating an existing status" do
    setup do
      login_as(User.create({ :login => "bob", :password => "mike" }))
      create_valid_status
      @status = Status.current
    end

    should "render the edit form" do
      get :edit, :id => @status

      assert_response :success
    end

    should "update the status" do
      put :update, :id => @status, :status => {:title => "Yeah!"}

      assert_equal "Yeah!", @status.reload.title
    end
  end

  context "Display the current status" do
    setup do
      @older_status = Status.create! :title => "All OK", :body => "...", :status => Status::OK
      @current_status = Status.create! :title => "All OK", :body => "...", :status => Status::OK
    end

    should "display the latest status" do
      get :current
      assert_equal @current_status, assigns(:status)
    end

    should "indicate ok status in custom header" do
      get :current

      assert_equal "Ok", response.headers["X-Gitorious-Status-Code"]
      assert_equal "All OK", response.headers["X-Gitorious-Status-Text"]
    end

    should "indicate down status in custom header" do
      Status.create :title => "Oh noes", :status => Status::DOWN
      get :current

      assert_equal "Down", response.headers["X-Gitorious-Status-Code"]
      assert_equal "Oh noes", response.headers["X-Gitorious-Status-Text"]
    end
  end

  def create_valid_status
    post :create, :status => {:title => "All OK", :body => "All systems go", :status => Status::OK}
  end

  def login_as(user)
    session[:current_user_id] = user.id
  end
end
