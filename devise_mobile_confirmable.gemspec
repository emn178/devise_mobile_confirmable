$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "devise_mobile_confirmable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "devise_mobile_confirmable"
  s.version     = DeviseMobileConfirmable::VERSION
  s.authors     = ["Chen, Yi-Cyuan"]
  s.email       = ["emn178@gmail.com"]
  s.homepage    = "https://github.com/emn178/devise_mobile_confirmable"
  s.summary     = "It adds support to devise for confirming users' mobile by SMS."
  s.description = "It adds support to devise for confirming users' mobile by SMS."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE.txt", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.2.0"
  s.add_dependency "devise"
  s.add_dependency "sms_carrier"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-its"
  s.add_development_dependency "generator_spec"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "coveralls"
  s.add_development_dependency "database_cleaner"
end
