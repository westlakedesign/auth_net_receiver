require 'rails_helper'

module AuthNetReceiver
  RSpec.describe RawTransactionsController, :type => :controller do

    routes { AuthNetReceiver::Engine.routes }

    it "should create a new raw transaction" do
      post :create 
      expect(response).to be_success
      expect(AuthNetReceiver::RawTransaction.count).to eq(1)
    end

  end
end
