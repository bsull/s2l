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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100914155828) do

  create_table "account_targets", :force => true do |t|
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "q1"
    t.integer  "q2"
    t.integer  "q3"
    t.integer  "q4"
    t.integer  "fiscal_year"
  end

  create_table "accounts", :force => true do |t|
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone"
    t.integer  "recent_period"
    t.integer  "fiscal_year_end"
  end

  create_table "confidences", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.string   "description"
    t.integer  "weight"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "opportunities", :force => true do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "customer_id"
    t.integer  "confidence_id"
    t.string   "name"
    t.decimal  "order_value"
    t.date     "order_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "status_change_date"
    t.string   "status"
    t.boolean  "stale"
    t.date     "update_requirement"
  end

  create_table "opportunity_records", :force => true do |t|
    t.integer  "opportunity_id"
    t.string   "salesman"
    t.decimal  "order_value"
    t.date     "order_date"
    t.integer  "days_to_order"
    t.string   "status"
    t.string   "confidence"
    t.integer  "weight"
    t.date     "created_at"
    t.datetime "updated_at"
  end

  create_table "user_targets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "fiscal_year"
    t.integer  "q1"
    t.integer  "q2"
    t.integer  "q3"
    t.integer  "q4"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.string   "nickname"
    t.string   "time_zone"
    t.string   "role"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
