# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "just_paginate"

Gem::Specification.new do |s|
  s.name        = "just_paginate"
  s.version     = JustPaginate::VERSION
  s.authors     = ["Gitorious AS"]
  s.email       = ["support@gitorious.org"]
  s.homepage    = "https://gitorious.org/gitorious/just_paginate"
  s.summary     = %q{Framework-agnostic support for paginating collections of things, and linking to paginated things in your webpage}
  s.description = %q{Framework-agnostic support for paginating collections of things, and linking to paginated things in your webpage}

  s.rubyforge_project = "just_paginate"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "minitest", "~> 2.0"
  s.add_development_dependency "rake"
end
