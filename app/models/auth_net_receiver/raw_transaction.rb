module AuthNetReceiver
  class RawTransaction < ActiveRecord::Base

    has_one :processed_transaction, :class_name => 'AuthNetReceiver::Transaction'
    scope :unprocessed, ->{ where(:is_processed => false) }
    scope :forgeries, ->{ where(:is_processed => true, :is_authentic => false) }

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

    def json_data
      begin
        return JSON.parse(self.data)
      rescue JSON::ParserError => e
        logger.fatal "Error while parsing raw transaction data: #{e.message}"
        return {}
      end
    end

    def process!
      if is_processed
        raise StandardError, 'The requested transaction has already been processed'
      else
        do_processing()
      end
    end

private

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

    def md5_hash_is_valid?(json)
      if AuthNetReceiver.config.hash_value.nil?
        raise StandardError, 'AuthNetReceiver.config.hash_value cannot be nil!'
      end
      if json['x_subscription_id'].present?
        hash_string = AuthNetReceiver.config.hash_value + json['x_trans_id'] + json['x_amount']
      else
        hash_string = AuthNetReceiver.config.hash_value + AuthNetReceiver.config.gateway_login + json['x_trans_id'] + json['x_amount']
      end
      hash = Digest::MD5.hexdigest(hash_string).upcase
      return hash == json['x_MD5_Hash']
    end

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
      rescue e
        fields[:amount] = nil
      end
      return fields
    end

  end
end
