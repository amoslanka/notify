class CreateNotificationDeliveries < ActiveRecord::Migration
  def change

    # Represents the join table between notifications and whatever is receiving.
    create_table :notification_deliveries do |t|
      t.references :receiver, polymorphic: true
      t.references :notification

      # The time at which we delivered.
      t.datetime :delivered_at
      # The time at which the user read it (and delivered a read confirmation).
      t.datetime :received_at

      t.timestamps
    end
  end
end
