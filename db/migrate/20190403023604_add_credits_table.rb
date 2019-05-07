class AddCreditsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :credits, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.uuid :identity_id
      t.uuid :ticket_id
      t.integer :time

      t.timestamps

      t.index :identity_id
      t.index :ticket_id
      t.index [:identity_id, :ticket_id]
      t.index :time
    end
  end
end
