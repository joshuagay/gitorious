require "./lib/use_case/version"

Gem::Specification.new do |s|
  s.name = "use_case"
  s.version = UseCase::VERSION
  s.author = "Christian Johansen"
  s.email = "christian@gitorious.com"
  s.homepage = "https://gitorious.org/gitorious/use_case"
  s.summary = "Encapsulate non-trivial Ruby business logic"
  s.description = "Compose non-trivial business logic into use cases that combine input parameter abstractions, system-level pre-conditions, input parameter validation, and commands."
  s.license = "MIT"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files test`.split("\n")
  s.require_path = "lib"

  s.add_development_dependency "minitest", "~> 4"
  s.add_development_dependency "rake"
end
