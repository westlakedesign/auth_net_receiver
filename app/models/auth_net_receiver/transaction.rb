module AuthNetReceiver
  class Transaction < ActiveRecord::Base
    
    belongs_to :raw_transaction
    validates_presence_of :raw_transaction_id

    def is_subscription?
      return self.subscription_id.present?
    end

  end
end
