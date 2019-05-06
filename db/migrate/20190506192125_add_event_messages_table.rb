class AddEventMessagesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :event_messages, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string :body

      t.timestamps
    end
  end
end
