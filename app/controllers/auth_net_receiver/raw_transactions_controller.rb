require_dependency "auth_net_receiver/application_controller"

module AuthNetReceiver
  class RawTransactionsController < ApplicationController

    skip_before_filter :verify_authenticity_token
  
    def create
      @raw_transaction = RawTransaction.create({
        :data => params.to_json
      })
      render :nothing => true, :status => 200
    end

  end
end
