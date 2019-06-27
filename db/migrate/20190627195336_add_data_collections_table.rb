class AddDataCollectionsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :data_collections, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.uuid :identity_id
      t.uuid :ticket_id

      t.string :label
      t.string :slug
      t.string :value
      t.string :scope

      t.timestamps

      t.index :identity_id
      t.index :ticket_id
      t.index :slug
      t.index [:slug, :identity_id]
      t.index [:slug, :ticket_id]
      t.index :scope
      t.index [:slug, :scope]
    end
  end
end
