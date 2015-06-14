# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arpdb/version'

Gem::Specification.new do |spec|
  spec.name          = "arpdb"
  spec.version       = Arpdb::VERSION
  spec.authors       = ["J.K.Valk"]
  spec.email         = ["jkvalk@mail.ru"]

  spec.summary       = %q{Arpdb is a Ruby gem for querying SNMP-enabled network devices for their ARP database.}
  spec.description   = "This is VERY raw, version 1.0.0 is expected to be first usable implementation."
  spec.homepage      = "https://github.com/jkvalk/arpdb"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.license = "MIT"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "pry"

  spec.add_dependency "snmp", '~> 1.2'
  spec.add_dependency "awesome_print", '~> 1.6'

end
