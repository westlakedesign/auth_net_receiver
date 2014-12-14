$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "auth_net_receiver/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "auth_net_receiver"
  s.version     = AuthNetReceiver::VERSION
  s.authors     = ["Greg Woods"]
  s.email       = ["greg@westlakedesign.com"]
  s.homepage    = "https://bitbucket.org/westlakedesign/auth_net_receiver"
  s.summary     = "Processor for Authorize.Net Silent Post transactions"
  s.description = "AuthNetReceiver is an endpoint and processor for Authorize.Net Silent Post transactions"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"].reject{ |f| f.match(/^spec\/dummy\/(log|tmp)/) }

  s.add_dependency "rails", "~> 4.2.0.rc3"

  s.add_development_dependency "mysql2"
  s.add_development_dependency 'rspec-rails', '~> 3.1.0'
  s.add_development_dependency 'factory_girl_rails', '~> 4.4.1'
  s.add_development_dependency 'database_cleaner', '~> 1.3.0'
  s.add_development_dependency 'simplecov', '~> 0.7.1'
end
