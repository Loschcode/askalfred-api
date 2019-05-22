class AddEventFilesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :event_files, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      # t.string :file <-- managed by active storage

      t.timestamps
    end
  end
end
