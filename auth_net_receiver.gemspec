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
  s.summary     = "Processor for Authorize.NET Silent Post transactions"
  s.description = "AuthNetReceiver is an endpoint and processor for transactions posted via Authorize.NET"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.0"

  s.add_development_dependency "mysql2"
end
