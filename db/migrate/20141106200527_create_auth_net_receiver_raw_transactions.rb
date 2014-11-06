class CreateAuthNetReceiverRawTransactions < ActiveRecord::Migration
  def change
    create_table :auth_net_receiver_raw_transactions do |t|
      t.boolean :is_processed, :default => false
      t.boolean :is_authentic, :default => false
      t.text :data
      t.timestamps :null => false
    end
  end
end
