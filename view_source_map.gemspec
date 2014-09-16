$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "view_source_map/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "view_source_map"
  s.version     = ViewSourceMap::VERSION
  s.authors     = ["Ryo Nakamura"]
  s.email       = ["r7kamura@gmail.com"]
  s.homepage    = "https://github.com/r7kamura/view_source_map"
  s.summary     = "Rails plugin to view source map"
  s.description = "This is a Rails plugin to insert the path name of " +
                  "a rendered partial view as HTML comment in development environment"
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 3.2"
  s.add_development_dependency "rspec-rails", "~> 2.99"
end
