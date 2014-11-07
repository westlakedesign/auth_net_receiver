# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :raw_transaction, :class => 'AuthNetReceiver::RawTransaction' do
    is_processed false
    is_authentic false
    data ""
  end
end
