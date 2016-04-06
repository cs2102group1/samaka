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

ActiveRecord::Schema.define(version: 20160224032527) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cars", primary_key: "car_plate", force: :cascade do |t|
    t.string "owner", null: false
  end

  create_table "drivers", id: false, force: :cascade do |t|
    t.string   "email",            null: false
    t.datetime "start_time",       null: false
    t.string   "car_plate",        null: false
    t.integer  "passenger_rating"
    t.text     "passenger_review"
  end

  add_index "drivers", ["start_time", "car_plate"], name: "drivers_start_time_car_plate_key", unique: true, using: :btree

  create_table "journeys", id: false, force: :cascade do |t|
    t.string   "pickup_point",    null: false
    t.string   "dropoff_point",   null: false
    t.float    "price",           null: false
    t.integer  "available_seats", null: false
    t.string   "car_plate",       null: false
    t.datetime "start_time",      null: false
  end

  create_table "passengers", id: false, force: :cascade do |t|
    t.string   "email",                        null: false
    t.datetime "start_time",                   null: false
    t.string   "car_plate",                    null: false
    t.integer  "driver_rating"
    t.text     "driver_review"
    t.boolean  "onboard",       default: true, null: false
  end

  add_index "passengers", ["start_time", "car_plate"], name: "passengers_start_time_car_plate_key", unique: true, using: :btree

  create_table "users", primary_key: "email", force: :cascade do |t|
    t.string   "username"
    t.string   "role",                                null: false
    t.string   "phone_number",                        null: false
    t.float    "credit"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "users_username_key", unique: true, using: :btree

  add_foreign_key "cars", "users", column: "owner", primary_key: "email", name: "cars_owner_fkey"
  add_foreign_key "drivers", "journeys", column: "start_time", primary_key: "start_time", name: "drivers_start_time_fkey"
  add_foreign_key "drivers", "users", column: "email", primary_key: "email", name: "drivers_email_fkey"
  add_foreign_key "passengers", "journeys", column: "start_time", primary_key: "start_time", name: "passengers_start_time_fkey"
  add_foreign_key "passengers", "users", column: "email", primary_key: "email", name: "passengers_email_fkey"
end
