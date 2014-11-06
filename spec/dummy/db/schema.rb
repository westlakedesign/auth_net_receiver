# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141106200940) do

  create_table "auth_net_receiver_raw_transactions", force: true do |t|
    t.boolean  "is_processed", default: false
    t.boolean  "is_authentic", default: false
    t.text     "data"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "auth_net_receiver_transactions", force: true do |t|
    t.integer  "raw_transaction_id"
    t.integer  "transaction_id",       limit: 8
    t.integer  "subscription_id",      limit: 8
    t.integer  "subscription_paynum"
    t.string   "invoice_num"
    t.string   "transaction_type"
    t.decimal  "amount",                         precision: 10, scale: 2, default: 0.0
    t.string   "card_type"
    t.string   "account_number"
    t.string   "description"
    t.integer  "response_reason_code"
    t.string   "response_reason_text"
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
  end

  add_index "auth_net_receiver_transactions", ["raw_transaction_id"], name: "index_auth_net_receiver_transactions_on_raw_transaction_id", using: :btree
  add_index "auth_net_receiver_transactions", ["subscription_id"], name: "index_auth_net_receiver_transactions_on_subscription_id", using: :btree
  add_index "auth_net_receiver_transactions", ["transaction_id"], name: "index_auth_net_receiver_transactions_on_transaction_id", using: :btree

end
