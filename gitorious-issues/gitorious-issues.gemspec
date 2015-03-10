$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "issues/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gitorious-issues"
  s.version     = Issues::VERSION
  s.authors     = ["Gitorious AS"]
  s.email       = ["piotr@gitorious.org"]
  s.homepage    = "https://gitorious.org"
  s.summary     = "Gitorious Issue Tracker"
  s.description = s.summary

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.15"
  s.add_dependency "charlatan", "~> 0.0.1"

  s.add_development_dependency "mysql2"
  s.add_development_dependency "minitest", "~> 4.7"
  s.add_development_dependency "minitest-rails", "~> 0.9.2"
  s.add_development_dependency "minitest-reporters", "~> 0.14"
  s.add_development_dependency "capybara", "~> 2.1"
  s.add_development_dependency "minitest-rails-capybara"
  s.add_development_dependency "capybara-screenshot"
  s.add_development_dependency "capybara_minitest_spec", "~> 1.0"
  s.add_development_dependency "poltergeist", "~> 1.4"
end
