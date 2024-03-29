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

ActiveRecord::Schema.define(version: 20171204194836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "software"
    t.string   "gateway"
    t.boolean  "omaha",           default: false
    t.boolean  "nashville",       default: false
    t.boolean  "north",           default: false
    t.boolean  "buypass",         default: false
    t.boolean  "elavon",          default: false
    t.boolean  "tsys",            default: false
    t.string   "source"
    t.string   "agent"
    t.string   "ticket"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "merchants_using"
    t.boolean  "other",           default: false
    t.index ["user_id"], name: "index_applications_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.string   "body"
    t.integer  "application_id"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["application_id"], name: "index_comments_on_application_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "admin",           default: false
  end

  add_foreign_key "applications", "users"
  add_foreign_key "comments", "applications"
  add_foreign_key "comments", "users"
end
