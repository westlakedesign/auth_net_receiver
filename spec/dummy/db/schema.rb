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

ActiveRecord::Schema.define(version: 20141214034232) do

  create_table "auth_net_receiver_raw_transactions", force: true do |t|
    t.boolean  "is_processed", limit: 1,     default: false
    t.boolean  "is_authentic", limit: 1,     default: false
    t.text     "data",         limit: 65535
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "auth_net_receiver_transactions", force: true do |t|
    t.integer  "raw_transaction_id",   limit: 4
    t.integer  "transaction_id",       limit: 8
    t.integer  "subscription_id",      limit: 8
    t.integer  "subscription_paynum",  limit: 4
    t.string   "invoice_num",          limit: 255
    t.string   "transaction_type",     limit: 255
    t.decimal  "amount",                           precision: 10, scale: 2, default: 0.0
    t.string   "card_type",            limit: 255
    t.string   "account_number",       limit: 255
    t.string   "description",          limit: 255
    t.integer  "response_reason_code", limit: 4
    t.string   "response_reason_text", limit: 255
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
  end

  add_index "auth_net_receiver_transactions", ["raw_transaction_id"], name: "index_auth_net_receiver_transactions_on_raw_transaction_id", using: :btree
  add_index "auth_net_receiver_transactions", ["subscription_id"], name: "index_auth_net_receiver_transactions_on_subscription_id", using: :btree
  add_index "auth_net_receiver_transactions", ["transaction_id"], name: "index_auth_net_receiver_transactions_on_transaction_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

end
