# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'csv2other/version'

Gem::Specification.new do |gem|
  gem.name          = "csv2other"
  gem.version       = Csv2other::VERSION
  gem.authors       = ["Nicolas Ledez"]
  gem.email         = ["github@ledez.net"]
  gem.description   = %q{A tiny gem to convert CSV files to other format with template}
  gem.summary       = %q{You prepare a template, use CSV to iterate and you have some informations}
  gem.homepage      = ""

  gem.add_dependency "nokogiri"

  gem.add_development_dependency "rspec"

  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "rb-fsevent"

  gem.add_development_dependency "growl"
  gem.add_development_dependency "spork"
  gem.add_development_dependency "guard-spork"

  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "json", '~> 1.7.7'
  gem.add_development_dependency "coveralls"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
