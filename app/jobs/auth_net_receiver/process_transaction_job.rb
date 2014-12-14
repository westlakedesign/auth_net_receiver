module AuthNetReceiver
  class ProcessTransactionJob < ActiveJob::Base
    queue_as :default

    def perform(raw_transaction)
      raw_transaction.process!
    end

  end
end
