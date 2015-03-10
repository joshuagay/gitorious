class Capybara::Rails::TestCase
  self.use_transactional_fixtures = false
  self.fixtures :all

  before do
    if metadata[:js]
      Capybara.current_driver = Capybara.javascript_driver
    end
  end

  after do
    if metadata[:js]
      DatabaseCleaner.clean_with(:truncation)
    end

    Capybara.reset_sessions!
    Capybara.current_driver = Capybara.default_driver
  end
end
