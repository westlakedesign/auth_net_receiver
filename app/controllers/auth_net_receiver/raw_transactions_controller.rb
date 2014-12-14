require_dependency "auth_net_receiver/application_controller"

module AuthNetReceiver
  class RawTransactionsController < ApplicationController

    skip_before_filter :verify_authenticity_token
    after_action :perform_job
  
    def create
      @raw_transaction = RawTransaction.create({
        :data => params.to_json
      })
      render :nothing => true, :status => 200
    end

private
    
    def perform_job
      if AuthNetReceiver.config.active_job
        AuthNetReceiver::ProcessTransactionJob.perform_later(@raw_transaction)
      end
    end

  end
end
