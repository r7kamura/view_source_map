$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "view_source_map/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "view_source_map"
  s.version     = ViewSourceMap::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ViewSourceMap."
  s.description = "TODO: Description of ViewSourceMap."
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.9"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
