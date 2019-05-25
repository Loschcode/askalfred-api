class AddCreditsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :credits, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.uuid :identity_id
      t.uuid :ticket_id
      t.integer :time
      t.string :origin

      t.string :stripe_charge_id

      t.timestamps

      t.index :identity_id
      t.index :ticket_id
      t.index [:identity_id, :ticket_id]
      t.index :time
      t.index :origin
      t.index :stripe_charge_id
    end
  end
end
