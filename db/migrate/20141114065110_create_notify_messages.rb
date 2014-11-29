class CreateNotifyMessages < ActiveRecord::Migration
  def change
    create_table :notify_messages do |t|
      t.string :strategy, required: true
      t.references :activity, polymorphic: true
      # Rules
      t.string :deliver_via
      t.boolean :visible
      t.string :policy
      t.datetime :expires_at
      t.timestamps
    end

    add_index :notify_messages, :strategy
    add_index :notify_messages, :visible
    add_index :notify_messages, :expires_at
    add_index :notify_messages, [:visible, :expires_at]
    add_index :notify_messages, [:activity_type, :activity_id]
  end
end
