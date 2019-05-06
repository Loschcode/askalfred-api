class AddCreditsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :credits, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string :identity_id
      t.string :thread_id
      t.integer :time

      t.timestamps

      t.index :identity_id
      t.index :thread_id
      t.index [:identity_id, :thread_id]
      t.index :time
    end
  end
end
