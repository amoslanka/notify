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

ActiveRecord::Schema.define(version: 20141119063650) do

  create_table "notification_deliveries", force: true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id"
    t.datetime "delivered_at"
    t.datetime "received_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.string   "type"
    t.integer  "activity_id"
    t.string   "activity_type"
    t.string   "deliver_via"
    t.boolean  "visible"
    t.string   "policy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["activity_type", "activity_id"], name: "index_notifications_on_activity_type_and_activity_id"
  add_index "notifications", ["type"], name: "index_notifications_on_type"

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end