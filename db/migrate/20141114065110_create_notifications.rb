class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :strategy, required: true
      t.references :activity, polymorphic: true
      # Rules
      t.string :deliver_via
      t.boolean :visible
      t.string :policy
      t.datetime :expires_at
      t.timestamps
    end

    add_index :notifications, :strategy
    add_index :notifications, :visible
    add_index :notifications, :expires_at
    add_index :notifications, [:visible, :expires_at]
    add_index :notifications, [:activity_type, :activity_id]
  end
end
