require 'rails_helper'

module AuthNetReceiver
  RSpec.describe Transaction, :type => :model do

    describe "#is_approved?" do

      it "should return true if response_reason_code is 1" do
        transaction = FactoryGirl.create(:transaction, {:response_reason_code => 1})
        expect(transaction.is_approved?).to eq(true)
      end

      it "should return false if response_reason_code is not 1" do
        transaction = FactoryGirl.create(:transaction, {:response_reason_code => 2})
        expect(transaction.is_approved?).to eq(false)
      end

    end

  end
end
