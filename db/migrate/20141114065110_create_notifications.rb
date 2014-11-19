class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :type, required: true
      t.references :activity, polymorphic: true
      # Rules
      t.string :deliver_via
      t.boolean :visible
      t.string :policy
      t.timestamps
    end

    add_index :notifications, :type
    add_index :notifications, [:activity_type, :activity_id]
  end
end
