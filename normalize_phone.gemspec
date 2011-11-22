# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "normalize_phone/version"

Gem::Specification.new do |s|
  s.name        = "normalize_phone"
  s.version     = NormalizePhone::VERSION
  s.authors     = ["pkw.de dev team"]
  s.email       = ["dev@pkw.de"]
  s.homepage    = ""
  s.summary     = %q{Normalizes phone numbers}
  s.description = %q{Normalizes phone numbers. Format '+CC ACN'.(CC=country code, AC=area code, N=number)}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake"
  s.add_development_dependency "test-unit"
  
  s.add_runtime_dependency "activesupport"
end
