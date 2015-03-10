if RUBY_VERSION > "1.9"
  require "simplecov"
  SimpleCov.start
end

require "bundler/setup"
require "minitest/autorun"
require "mocha"
