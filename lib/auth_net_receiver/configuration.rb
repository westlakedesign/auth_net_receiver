module AuthNetReceiver
  include ActiveSupport::Configurable
  config_accessor :hash_value, :gateway_login, :active_job
  self.hash_value = nil
  self.gateway_login = nil
  self.active_job = defined?(ActiveJob) != nil
end
