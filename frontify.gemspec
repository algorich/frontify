$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "frontify/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "frontify"
  s.version     = Frontify::VERSION
  s.authors     = ["Dyogo Ribeiro Veiga"]
  s.email       = ["dyogo.nsi@gmail.com"]
  s.homepage    = ""
  s.summary     = ""
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5.2"
  s.add_dependency 'safe_yaml', '~> 1.0'
  s.add_dependency 'redcarpet'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "bundler", "~> 1.13"
  s.add_development_dependency "rake", "~> 10.0"
end
