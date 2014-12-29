require "auth_net_receiver/configuration"
require "auth_net_receiver/active_job" if defined?(ActiveJob)

module AuthNetReceiver
  class Engine < ::Rails::Engine
    isolate_namespace AuthNetReceiver

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

  end
end
