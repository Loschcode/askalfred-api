class AddEventsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :events, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.uuid :identity_id
      t.uuid :ticket_id

      # polymorphic
      t.string :eventable_type
      t.uuid :eventable_id

      t.timestamps

      t.index :identity_id
      t.index :ticket_id
    end
  end
end
