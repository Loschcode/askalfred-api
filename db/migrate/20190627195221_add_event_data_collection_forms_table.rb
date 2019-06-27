class AddEventDataCollectionFormsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :event_data_collection_forms, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string :body

      t.datetime :sent_at

      t.timestamps

      t.index :sent_at
    end
  end
end
