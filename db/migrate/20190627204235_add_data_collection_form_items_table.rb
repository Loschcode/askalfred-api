class AddDataCollectionFormItemsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :data_collection_form_items, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.uuid :event_data_collection_form_id
      t.uuid :data_collection_id

      t.timestamps

      t.index [:event_data_collection_form_id, :data_collection_id], name: 'data_collections_event_data_collection_forms'
    end
  end
end
