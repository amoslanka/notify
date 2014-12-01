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

  create_table "notify_deliveries", force: true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notify_message_id"
    t.datetime "delivered_at"
    t.datetime "received_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notify_deliveries", ["notify_message_id"], name: "index_notify_deliveries_on_notify_message_id"
  add_index "notify_deliveries", ["receiver_type", "receiver_id"], name: "index_notify_deliveries_on_receiver_type_and_receiver_id"

  create_table "notify_messages", force: true do |t|
    t.string   "notification_name"
    t.integer  "activity_id"
    t.string   "activity_type"
    t.string   "deliver_via"
    t.boolean  "visible"
    t.string   "policy"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notify_messages", ["activity_type", "activity_id"], name: "index_notify_messages_on_activity_type_and_activity_id"
  add_index "notify_messages", ["expires_at"], name: "index_notify_messages_on_expires_at"
  add_index "notify_messages", ["notification_name"], name: "index_notify_messages_on_notification_name"
  add_index "notify_messages", ["visible", "expires_at"], name: "index_notify_messages_on_visible_and_expires_at"
  add_index "notify_messages", ["visible"], name: "index_notify_messages_on_visible"

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
