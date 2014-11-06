module AuthNetReceiver
  include ActiveSupport::Configurable
  config_accessor :hash_value, :gateway_login
  self.hash_value = nil
  self.gateway_login = nil
end
