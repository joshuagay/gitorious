# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitorious/search/version'

Gem::Specification.new do |spec|
  spec.name          = "gitorious-search"
  spec.version       = Gitorious::Search::VERSION
  spec.authors       = ["Marius Mathiesen"]
  spec.email         = ["marius@gitorious.com"]
  spec.description   = %q{Search API for Gitorious}
  spec.summary       = %q{Wrapper for Thinking Sphinx, 2.x and 3.x}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  if RUBY_VERSION < "1.9"
    spec.add_dependency "thinking-sphinx", "~> 2.0"
  else
    spec.add_dependency "thinking-sphinx", "~> 3.0"
  end
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
