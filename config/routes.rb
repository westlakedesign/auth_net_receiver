AuthNetReceiver::Engine.routes.draw do
  post 'transactions/receiver' => 'raw_transactions#create'
end
