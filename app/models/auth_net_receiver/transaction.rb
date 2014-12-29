module AuthNetReceiver
  class Transaction < ActiveRecord::Base
    
    scope :approved, ->{ where(:response_reason_code => 1) }

    belongs_to :raw_transaction
    validates_presence_of :raw_transaction_id

    # Return true if this record belongs to an Automated Recurring Billing subscription
    #
    def is_subscription?
      return self.subscription_id.present?
    end

    # Return true if the transaction was succesful
    # This will be indicated by a Response Reason Code 1. All other codes indicate an error of some kind
    # http://developer.authorize.net/tools/responsereasoncode/
    #
    def is_approved?
      return response_reason_code == 1
    end

  end
end
