# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'netzke-extension/version'

Gem::Specification.new do |gem|
  gem.name          = 'netzke-extension'
  gem.version       = Netzke::Extension::VERSION
  gem.authors       = ['phgrey']
  gem.email         = ['phgrey@gmail.com']
  gem.description   = %q{Several components + coffee-script-written code }
  gem.summary       = %q{My own netzke extensions}
  gem.homepage      = ''

  gem.files         = Dir["{app,config,db,lib}/**/*"] + ["LICENSE.txt", "Rakefile", "README.md"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
  #requirements for dummy-app
  gem.add_development_dependency "rails", "~> 3.2.13"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "jquery-rails"
  gem.add_development_dependency "rspec-rails"

  gem.add_dependency 'netzke-core', '~> 0.8'
  gem.add_dependency 'netzke-basepack', '~> 0.8'
  gem.add_dependency 'coffee-script'
end
