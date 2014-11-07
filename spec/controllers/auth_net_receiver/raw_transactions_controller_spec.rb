require 'rails_helper'

module AuthNetReceiver
  RSpec.describe RawTransactionsController, :type => :controller do

    it "should create a new raw transaction" do
      post :create, {:use_route => :auth_net_receiver}
      expect(response).to be_success
      expect(AuthNetReceiver::RawTransaction.unprocessed.count).to eq(1)
    end

  end
end
