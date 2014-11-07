require 'rails_helper'
require 'sample_data'

RSpec.configure do |c|
  c.include AuthNetReceiver::SampleData
end

module AuthNetReceiver
  RSpec.describe RawTransaction, :type => :model do
    
    describe "::process_all!" do
      it "should process all pending transactions" do
        3.times do
          FactoryGirl.create(:raw_transaction, :data => authentic_transaction.to_json)
        end
        2.times do
          FactoryGirl.create(:raw_transaction, :data => forged_transaction.to_json)
        end
        result = AuthNetReceiver::RawTransaction.process_all!
        expect(result[:authentic]).to eq(3)
        expect(result[:forgeries]).to eq(2)
        expect(AuthNetReceiver::RawTransaction.unprocessed.count).to eq(0)
      end
    end

    describe "#process!" do
      it "should process an authentic transaction" do
        raw_transaction = FactoryGirl.create(:raw_transaction, :data => authentic_transaction.to_json)
        raw_transaction.process!
        expect(raw_transaction.is_processed).to eq(true)
        expect(raw_transaction.is_authentic).to eq(true)
        expect(raw_transaction.processed_transaction).to_not be_nil
      end

      it "should process a forged transaction" do
        raw_transaction = FactoryGirl.create(:raw_transaction, :data => forged_transaction.to_json)
        raw_transaction.process!
        expect(raw_transaction.is_processed).to eq(true)
        expect(raw_transaction.is_authentic).to eq(false)
        expect(raw_transaction.processed_transaction).to be_nil
      end

      it "should process an authentic subscription" do
        raw_transaction = FactoryGirl.create(:raw_transaction, :data => authentic_subscription.to_json)
        raw_transaction.process!
        expect(raw_transaction.is_processed).to eq(true)
        expect(raw_transaction.is_authentic).to eq(true)
        expect(raw_transaction.processed_transaction.is_subscription?).to be(true)
      end

      it "should not process the same raw transaction twice" do
        raw_transaction = FactoryGirl.create(:raw_transaction, :data => authentic_transaction.to_json)
        raw_transaction.process!
        expect{
          raw_transaction.process!
        }.to raise_error
      end

      it "should pass the correct values from the json" do
        data = authentic_transaction
        raw_transaction = FactoryGirl.create(:raw_transaction, :data => data.to_json)
        raw_transaction.process!
        t = raw_transaction.processed_transaction

        expect(t.subscription_id).to      eq(data['x_subscription_id'])
        expect(t.subscription_paynum).to  eq(data['x_subscription_paynum'])
        expect(t.invoice_num).to          eq(data['x_invoice_num'])
        expect(t.transaction_type).to     eq(data['x_type'])
        expect(t.amount).to               eq(BigDecimal.new(data['x_amount']))
        expect(t.card_type).to            eq(data['x_card_type'])
        expect(t.account_number).to       eq(data['x_account_number'])
        expect(t.description).to          eq(data['x_description'])
        expect(t.response_reason_code).to eq(data['x_response_reason_code'].to_i)
        expect(t.response_reason_text).to eq(data['x_response_reason_text'])
      end
    end

  end
end
