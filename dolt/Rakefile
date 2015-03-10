require "rake/testtask"
require "ci/reporter/rake/minitest"
require "bundler/gem_tasks"

Rake::TestTask.new("test") do |test|
  test.libs << "test"
  test.pattern = "test/**/*_test.rb"
  test.verbose = true
end

task :default => :test
