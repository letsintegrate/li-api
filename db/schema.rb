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

ActiveRecord::Schema.define(version: 20160901120504) do

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

  create_table "location_translations", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "location_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
  end

  add_index "location_translations", ["locale"], name: "index_location_translations_on_locale", using: :btree
  add_index "location_translations", ["location_id"], name: "index_location_translations_on_location_id", using: :btree

  create_table "locations", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "images",         default: [],                 array: true
    t.string   "slug"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "active",         default: true
    t.boolean  "special",        default: false
    t.boolean  "phone_required"
    t.uuid     "region_id",                      null: false
  end

  add_index "locations", ["active"], name: "index_locations_on_active", using: :btree
  add_index "locations", ["region_id"], name: "index_locations_on_region_id", using: :btree
  add_index "locations", ["special"], name: "index_locations_on_special", using: :btree

  create_table "oauth_access_grants", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "resource_owner_id", null: false
    t.uuid     "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "resource_owner_id"
    t.uuid     "application_id",                      null: false
    t.string   "token",                               null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                          null: false
    t.string   "scopes"
    t.string   "previous_refresh_token", default: "", null: false
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

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
    t.string   "phone"
  end

  create_table "regions", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "country"
    t.string   "sender_email"
    t.boolean  "active",       default: true
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "regions", ["slug"], name: "index_regions_on_slug", unique: true, using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

  add_foreign_key "appointments", "locations"
  add_foreign_key "appointments", "offer_times"
  add_foreign_key "appointments", "offers"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "offer_locations", "locations"
  add_foreign_key "offer_locations", "offers"
  add_foreign_key "offer_times", "offers"
end
