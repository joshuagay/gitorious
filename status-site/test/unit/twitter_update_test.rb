require 'test_helper'

class TwitterUpdateTest < ActiveSupport::TestCase
  should "build a message" do
    status = Status.new(:title => "OK", :body => "Whatever", :status => Status::OK)
    assert_equal "[UP] OK: Whatever", twitter_update(status)
  end

  should "discard body when message too long" do
    status = Status.new(:title => "OK", :body => "Whatever" + ("!" * 124), :status => Status::OK)
    assert_equal "[UP] OK", twitter_update(status)
  end

  should "not use a colon if no body provided" do
    status = Status.new(:title => "OK", :status => Status::OK)
    assert_equal "[UP] OK", twitter_update(status)
  end

  should "format down message" do
    status = Status.new(:status => Status::DOWN)
    assert_match "[DOWN]", twitter_update(status)
  end

  should "format sorta partially up message" do
    status = Status.new(:status => Status::SORTA)

    assert_match "[SOME ISSUES]", twitter_update(status)
    assert_match "http://status.gitorious.org", twitter_update(status)
  end

  should "discard body for sorta when body too long" do
    status = Status.new(:status => Status::SORTA, :title => "OK", :body => "!" * 123)

    refute_match "!", twitter_update(status)
  end

  should "only post if authentication succeeds" do
    ENV["TWITTER_OAUTH_KEY"] = nil
    TwitterUpdate.update do
      flunk
    end
  end

  should "Require 4 env vars to work with Twitter" do
    %w[TWITTER_OAUTH_KEY TWITTER_OAUTH_SECRET TWITTER_CONSUMER_KEY TWITTER_CONSUMER_SECRET].each {|k| ENV[k] = 'whatever'}
    stuff = TwitterUpdate.update do
      "whatever"
    end
    assert_equal "whatever", stuff
  end

  def twitter_update(status)
    TwitterUpdate.new(status).message
  end
end
