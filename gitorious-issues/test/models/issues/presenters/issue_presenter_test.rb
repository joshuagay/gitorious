require 'test_helper'

module Issues
  describe Presenters::IssuePresenter do
    it "delegates to_param to issue" do
      issue = stub(to_param: '1-issue')
      presenter = Presenters::IssuePresenter.new(issue)

      presenter.to_param.must_equal '1-issue'
    end

    it "defines model_name" do
      Presenters::IssuePresenter.model_name.must_equal(Issue.model_name)
    end

    it "returns priority name" do
      Issue::PRIORITIES.each do |value, name|
        issue = stub(priority: value)
        presenter = Presenters::IssuePresenter.new(issue)

        presenter.priority_name.must_equal(name)
      end
    end

    it "returns fullname as a username" do
      issue = stub(user: stub(fullname: 'Joe Doe', login: 'joe'))
      presenter = Presenters::IssuePresenter.new(issue)

      presenter.user_name.must_equal('Joe Doe')
    end

    it "returns login as username if there is no fullname" do
      issue = stub(user: stub(fullname: nil, login: 'joe'))
      presenter = Presenters::IssuePresenter.new(issue)

      presenter.user_name.must_equal('joe')
    end
  end
end
