# This migration comes from auth_net_receiver (originally 20141106200940)
class CreateAuthNetReceiverTransactions < ActiveRecord::Migration
  def change
    create_table :auth_net_receiver_transactions do |t|
      t.references :raw_transaction, :index => true
      t.references :transaction, :index => true, :limit => 8
      t.references :subscription, :index => true, :limit => 8
      t.integer :subscription_paynum
      t.string :invoice_num
      t.string :transaction_type
      t.decimal :amount, :precision => 10, :scale => 2, :default => 0
      t.string :card_type
      t.string :account_number
      t.string :description
      t.integer :response_reason_code
      t.string :response_reason_text
      t.timestamps :null => false
    end
  end
end
