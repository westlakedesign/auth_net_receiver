module AuthNetReceiver
  class RawTransaction < ActiveRecord::Base

    has_one :processed_transaction, :class_name => 'AuthNetReceiver::Transaction'
    scope :unprocessed, ->{ where(:is_processed => false) }
    scope :forgeries, ->{ where(:is_processed => true, :is_authentic => false) }

    # Process all raw transactions
    #
    # * Returns a hash of counts in the form of:
    #     {:authentic => 0, :forgeries => 0, :errors => 0}
    #
    def self.process_all!
      result = {:authentic => 0, :forgeries => 0, :errors => 0}
      unprocessed.each do |raw_transaction|
        if raw_transaction.process!
          result[:authentic] += 1
        elsif raw_transaction.errors.any?
          result[:errors] += 1
        else
          result[:forgeries] += 1
        end
      end
      return result
    end

    # Return the JSON data on this record as a hash
    #
    def json_data
      begin
        return JSON.parse(self.data)
      rescue JSON::ParserError, TypeError => e
        logger.warn "Error while parsing raw transaction data: #{e.message}"
        return {}
      end
    end

    # Process this transaction
    #
    def process!
      if is_processed
        raise StandardError, 'The requested transaction has already been processed'
      else
        do_processing()
      end
    end

private

    # Perform the actual processing, update the status columns, and create an AuthNetReceiver::Transaction record
    #
    def do_processing
      json = self.json_data
      if md5_hash_is_valid?(json)
        fields = fields_from_json(json).merge({:raw_transaction_id => self.id})
        transaction = Transaction.new(fields)
        if transaction.save()
          self.update_attributes(:is_processed => true, :is_authentic => true)
          return true
        else
          return false
        end
      else
        self.update_attributes(:is_processed => true, :is_authentic => false)
        return false
      end
    end

    # Check that the x_MD5_Hash value matches our expectations
    #
    # The formula for the hash differs for subscription vs regular transactions. Regular transactions
    # will be associated with the gateway ID that was used in the originating API call. Subscriptions
    # however are ran on the server at later date, and therefore will not be associated to a gateway ID.
    #
    # * Subscriptions: MD5 Digest(AUTH_NET_HASH_VAL + TRANSACTION_ID + TRANSACTION_AMOUNT)
    # * Other Transactions: MD5 Digest(AUTH_NET_HASH_VAL + GATEWAY_LOGIN + TRANSACTION_ID + TRANSACTION_AMOUNT)
    #
    def md5_hash_is_valid?(json)
      if AuthNetReceiver.config.hash_value.nil? || AuthNetReceiver.config.gateway_login.nil?
        raise StandardError, 'AuthNetReceiver hash_value and gateway_login cannot be nil!'
      end
      parts = []
      parts << AuthNetReceiver.config.hash_value
      parts << AuthNetReceiver.config.gateway_login if json['x_subscription_id'].blank?
      parts << json['x_trans_id']
      parts << json['x_amount']
      hash = Digest::MD5.hexdigest(parts.join()).upcase
      return hash == json['x_MD5_Hash']
    end

    # Generate the AuthNetReceiver::Transaction model fields from the given JSON data
    #
    def fields_from_json(json)
      fields = {
        :transaction_id => json['x_trans_id'],
        :invoice_num => json['x_invoice_num'],
        :subscription_id => json['x_subscription_id'],
        :subscription_paynum => json['x_subscription_paynum'],
        :transaction_type => json['x_type'],
        :card_type => json['x_card_type'],
        :account_number => json['x_account_number'],
        :description => json['x_description'],
        :response_reason_code => json['x_response_reason_code'],
        :response_reason_text => json['x_response_reason_text']
      }
      begin
        fields[:amount] = BigDecimal.new(json['x_amount'])
      rescue TypeError
        fields[:amount] = nil
      end
      return fields
    end

  end
end
