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
    t.string   "strategy"
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
  add_index "notify_messages", ["strategy"], name: "index_notify_messages_on_strategy"
  add_index "notify_messages", ["visible", "expires_at"], name: "index_notify_messages_on_visible_and_expires_at"
  add_index "notify_messages", ["visible"], name: "index_notify_messages_on_visible"

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
