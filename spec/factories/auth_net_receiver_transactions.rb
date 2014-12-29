# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction, :class => 'AuthNetReceiver::Transaction' do
    association :raw_transaction, :factory => :raw_transaction
    transaction_id 1
    subscription_id 1
    subscription_paynum 1
    invoice_num "MyString"
    transaction_type "MyString"
    amount 9.99
    card_type "MyString"
    account_number "MyString"
    description "MyString"
    response_reason_code 1
    response_reason_text "MyString"
  end
end
