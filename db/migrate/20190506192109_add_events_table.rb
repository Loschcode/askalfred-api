class AddEventsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :events, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string :identity_id
      t.string :ticket_id

      # polymorphic
      t.string :eventable_type
      t.string :eventable_id

      t.timestamps

      t.index :identity_id
      t.index :ticket_id
    end
  end
end
