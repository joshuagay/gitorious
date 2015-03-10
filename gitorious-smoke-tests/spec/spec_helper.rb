require 'rspec'
require 'capybara'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara-screenshot'
require 'capybara-screenshot/rspec'
require 'securerandom'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

HOST = ENV['GTS_HOST'] || 'http://vagrant'
USER = ENV['GTS_USER'] || 'test'
PASS = ENV['GTS_PASS'] || 'testtest'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, phantomjs_options: ['--ignore-ssl-errors=yes'])
end

Capybara.default_driver = ENV['CAPYBARA_DRIVER'] ? ENV['CAPYBARA_DRIVER'].to_sym : :poltergeist
Capybara.run_server = false
Capybara.app_host = HOST
Capybara.default_wait_time = 5

Capybara.save_and_open_page_path = "tmp"
