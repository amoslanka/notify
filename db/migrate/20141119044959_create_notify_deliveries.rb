class CreateNotifyDeliveries < ActiveRecord::Migration
  def change

    # Represents the join table between messages and whatever is receiving.
    create_table :notify_deliveries do |t|
      t.references :receiver, polymorphic: true
      t.references :notify_message

      # The time at which we delivered.
      t.datetime :delivered_at
      # The time at which the user read it (and delivered a read confirmation).
      t.datetime :received_at

      t.timestamps
    end

    add_index :notify_deliveries, :notify_message_id
    add_index :notify_deliveries, [:receiver_type, :receiver_id]
  end
end
