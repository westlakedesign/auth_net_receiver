Rails.application.routes.draw do
  mount AuthNetReceiver::Engine => "/auth_net_receiver"
end
