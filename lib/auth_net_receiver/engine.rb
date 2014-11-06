require "auth_net_receiver/configuration"

module AuthNetReceiver
  class Engine < ::Rails::Engine
    isolate_namespace AuthNetReceiver
  end
end
