# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "alibris/version"

Gem::Specification.new do |s|
  s.name        = "ruby-alibris"
  s.version     = Alibris::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rupak Ganguly"]
  s.date        = %q{2011-04-27}
  s.email       = ["rupakg@gmail.com"]
  s.homepage    = %q{http://github.com/rupakg/ruby-alibris}
  s.summary     = %q{Wrapper for Alibris API}
  s.description = %q{Wrapper for Alibris API, the premier online marketplace for independent sellers of new and used books, music, and movies, as well as rare and collectible titles.}
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<hashie>, ["~> 1.0.0"])
  s.add_runtime_dependency(%q<httparty>, ["~> 0.7.0"])
  s.add_development_dependency(%q<shoulda>, [">= 2.10.1"])
  s.add_development_dependency(%q<jnunemaker-matchy>, ["= 0.4.0"])
  s.add_development_dependency(%q<mocha>, ["~> 0.9.12"])
  s.add_development_dependency(%q<fakeweb>, ["~> 1.3.0"])

end
