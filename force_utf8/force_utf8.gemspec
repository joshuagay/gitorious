# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'force_utf8/version'

Gem::Specification.new do |spec|
  spec.name          = "force_utf8"
  spec.version       = ForceUtf8::VERSION
  spec.authors       = ["Adam Pohorecki"]
  spec.email         = ["adam@pohorecki.pl"]
  spec.description   = %q{Convert any Ruby string to UTF8.}
  spec.summary       = %q{Convert any Ruby string to UTF8.}
  spec.homepage      = "https://gitorious.org/gitorious/force_utf8"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
