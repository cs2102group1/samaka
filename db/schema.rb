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

ActiveRecord::Schema.define(version: 20160218092914) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drivers", id: false, force: :cascade do |t|
    t.string   "email",            null: false
    t.datetime "start",            null: false
    t.string   "car_plate",        null: false
    t.integer  "passenger_rating"
    t.text     "passenger_review"
  end

  create_table "journeys", id: false, force: :cascade do |t|
    t.string   "pickup_point",    null: false
    t.string   "dropoff_point",   null: false
    t.float    "price",           null: false
    t.integer  "available_seats", null: false
    t.string   "car_plate",       null: false
    t.datetime "start",           null: false
  end

  create_table "passengers", id: false, force: :cascade do |t|
    t.string   "email",                        null: false
    t.datetime "start",                        null: false
    t.string   "car_plate",                    null: false
    t.integer  "driver_rating"
    t.text     "driver_review"
    t.boolean  "onboard",       default: true, null: false
  end

  create_table "users", primary_key: "email", force: :cascade do |t|
    t.string  "username",                  null: false
    t.integer "role",                      null: false
    t.string  "phone_number",              null: false
    t.text    "carplates",    default: [],              array: true
  end

  add_foreign_key "drivers", "journeys", column: "start", primary_key: "start", name: "drivers_start_fkey", on_delete: :cascade
  add_foreign_key "drivers", "users", column: "email", primary_key: "email", name: "drivers_email_fkey", on_delete: :cascade
  add_foreign_key "passengers", "journeys", column: "start", primary_key: "start", name: "passengers_start_fkey", on_delete: :cascade
  add_foreign_key "passengers", "users", column: "email", primary_key: "email", name: "passengers_email_fkey", on_delete: :cascade
end
