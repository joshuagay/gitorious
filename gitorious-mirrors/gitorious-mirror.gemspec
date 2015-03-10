Gem::Specification.new do |s|
  s.name        = "gitorious-mirror"
  s.version     = "0.0.1"
  s.authors     = ["Marius Mathiesen","Piotr Solnica"]
  s.email       = ["marius@gitorious.com"]
  s.homepage    = "http://gitorious.org/gitorious/gitorious-mirror"
  s.summary     = %q{An SSH shell for Gitorious mirroring}
  s.description = %q{A shell-like program which in addition to git push supports creating, cloning and deleting Git repositories}

  s.rubyforge_project = "gitorious-mirrors"

  s.add_development_dependency "minitest", "~> 2.0"
  s.add_development_dependency "rake", "~> 0.9"

  s.files         = `git ls-files -- lib/**`.split("\n")
  s.test_files    = `git ls-files -- {test}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
