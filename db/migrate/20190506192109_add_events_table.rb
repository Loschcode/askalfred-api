class AddEventsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :events, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string :identity_id
      t.string :thread_id

      t.references :eventable, polymorphic: true

      t.timestamps

      t.index :identity_id
      t.index :thread_id
    end
  end
end
