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

ActiveRecord::Schema.define(version: 20160419073347) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "addresses", force: :cascade do |t|
    t.float    "latitude",           null: false
    t.float    "longitude",          null: false
    t.string   "street_1",           null: false
    t.string   "street_2"
    t.string   "city"
    t.string   "state_abbreviation", null: false
    t.string   "zip_code"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "campaign_volunteers", force: :cascade do |t|
    t.integer  "volunteer_id", null: false
    t.integer  "campaign_id",  null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "campaign_volunteers", ["campaign_id"], name: "index_campaign_volunteers_on_campaign_id", using: :btree
  add_index "campaign_volunteers", ["volunteer_id"], name: "index_campaign_volunteers_on_volunteer_id", using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.string   "title",       null: false
    t.text     "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "congressional_districts", force: :cascade do |t|
    t.integer  "united_states_subdivision_id",                                          null: false
    t.integer  "number",                                                                null: false
    t.string   "state_postal_abbreviation",                                             null: false
    t.string   "state_name",                                                            null: false
    t.integer  "congress_session",                                                      null: false
    t.geometry "polygon",                      limit: {:srid=>4326, :type=>"geometry"}, null: false
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
  end

  add_index "congressional_districts", ["polygon"], name: "index_congressional_districts_on_polygon", using: :gist

  create_table "devices", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token"
    t.boolean  "enabled"
    t.string   "platform"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "devices", ["token"], name: "index_devices_on_token", unique: true, using: :btree
  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "united_states_subdivisions", force: :cascade do |t|
    t.string   "name",                null: false
    t.string   "postal_abbreviation", null: false
    t.string   "fips_code",           null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "united_states_subdivisions", ["fips_code"], name: "index_united_states_subdivisions_on_fips_code", using: :btree
  add_index "united_states_subdivisions", ["postal_abbreviation"], name: "index_united_states_subdivisions_on_postal_abbreviation", using: :btree

  create_table "user_relationships", force: :cascade do |t|
    t.integer  "follower_id",  null: false
    t.integer  "following_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "user_relationships", ["follower_id", "following_id"], name: "index_user_relationships_on_follower_id_and_following_id", unique: true, using: :btree
  add_index "user_relationships", ["follower_id"], name: "index_user_relationships_on_follower_id", using: :btree
  add_index "user_relationships", ["following_id"], name: "index_user_relationships_on_following_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                             null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "encrypted_password",    limit: 128
    t.string   "confirmation_token",    limit: 128
    t.string   "remember_token",        limit: 128
    t.string   "base_64_photo_data"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "facebook_id"
    t.string   "facebook_access_token"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  add_foreign_key "campaign_volunteers", "campaigns"
  add_foreign_key "campaign_volunteers", "users", column: "volunteer_id"
  add_foreign_key "devices", "users"
end
