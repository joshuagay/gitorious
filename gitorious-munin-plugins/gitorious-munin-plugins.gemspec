$:.push File.expand_path("../lib", __FILE__)
require "gitorious-munin-plugins/version"

Gem::Specification.new do |s|
  s.name        = "gitorious-munin-plugins"
  s.version     = GitoriousMuninPlugins::VERSION
  s.authors     = ["Marius Mathiesen"]
  s.email       = ["marius@gitorious.com"]
  s.homepage    = "http://gitorious.org/gitorious/gitorious-munin-plugins"
  s.summary     = "Gitorious Munin Plugins"
  s.description = "A binary that can be used as Munin plugins for a Gitorious server by linking to it under different names."

  s.files         = `git ls-files`.split("\n") - [".gitignore", "readme.org"]
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "mysql", "~> 2.8"
  s.add_dependency "term-ansicolor", "~> 1.0"
  s.add_dependency "trollop", "~> 2.0"
end
