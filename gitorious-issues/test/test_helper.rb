# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

host_app_root = Pathname('../../').expand_path
$LOAD_PATH.unshift(File.join(host_app_root, 'app/models'))
$LOAD_PATH.unshift(File.join(host_app_root, 'lib'))
$LOAD_PATH.unshift(Pathname(__FILE__).expand_path.join('lib'))

require File.expand_path(File.join(host_app_root, 'config/environment'))
require "rails/test_help"

require "minitest/spec"
require "minitest/rails/capybara"
require "minitest/reporters"

require "database_cleaner"

require "capybara/poltergeist"
require "capybara-screenshot/minitest"
require host_app_root.join('test/capybara_test_case')

Minitest::Reporters.use!(Minitest::Reporters::DefaultReporter.new)

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, :window_size => [1440, 900])
end

gts_conf = Gitorious::Configuration

Capybara.javascript_driver = :poltergeist
Capybara.default_host      = 'gitorious.test'

Capybara.configure do |config|
  config.javascript_driver = :poltergeist
  config.server_port       = 3001
  config.app_host          = "#{gts_conf.get('scheme')}://#{gts_conf.get('client_host')}:#{gts_conf.get('client_port')}"
end

DatabaseCleaner.strategy = :truncation

WebMock.disable_net_connect!(:allow_localhost => true)

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Assertions
end

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

require 'pathname'

require 'gitorious'
require 'gitorious/authorization'
require 'gitorious/protectable'

require 'url_linting'
require 'watchable'
require 'index_hint'

require 'repository'
require 'wiki_repository'

require 'record_throttling'
require 'action'
require 'group_behavior'
require 'group'

require 'user'
require 'project'

ActiveSupport::TestCase.fixture_path = File.join(host_app_root, 'test/fixtures')
