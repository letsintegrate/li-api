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

ActiveRecord::Schema.define(version: 20160516195513) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "appointments", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "offer_time_id"
    t.uuid     "offer_id"
    t.uuid     "location_id"
    t.string   "email"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.string   "cancelation_token"
    t.datetime "canceled_at"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "locale",                  limit: 2, default: "en"
    t.datetime "reminder_sent"
    t.inet     "confirmation_ip_address"
    t.string   "country"
    t.string   "city"
    t.float    "lng"
    t.float    "lat"
  end

  add_index "appointments", ["location_id"], name: "index_appointments_on_location_id", using: :btree
  add_index "appointments", ["offer_id"], name: "index_appointments_on_offer_id", using: :btree
  add_index "appointments", ["offer_time_id"], name: "index_appointments_on_offer_time_id", using: :btree
  add_index "appointments", ["reminder_sent"], name: "index_appointments_on_reminder_sent", using: :btree

  create_table "locations", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "images",      default: [],              array: true
    t.string   "slug"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "offer_locations", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "location_id"
    t.uuid     "offer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "offer_locations", ["location_id"], name: "index_offer_locations_on_location_id", using: :btree
  add_index "offer_locations", ["offer_id"], name: "index_offer_locations_on_offer_id", using: :btree

  create_table "offer_times", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "offer_id"
    t.datetime "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "offer_times", ["offer_id"], name: "index_offer_times_on_offer_id", using: :btree

  create_table "offers", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "email"
    t.string   "confirmation_token"
    t.string   "cancelation_token"
    t.datetime "confirmed_at"
    t.datetime "canceled_at"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "locale",                  limit: 2, default: "en"
    t.inet     "confirmation_ip_address"
    t.string   "country"
    t.string   "city"
    t.float    "lng"
    t.float    "lat"
  end

  add_foreign_key "appointments", "locations"
  add_foreign_key "appointments", "offer_times"
  add_foreign_key "appointments", "offers"
  add_foreign_key "offer_locations", "locations"
  add_foreign_key "offer_locations", "offers"
  add_foreign_key "offer_times", "offers"
end
