class AddEventCallToActionTable < ActiveRecord::Migration[5.2]
  def change
    create_table :event_call_to_actions, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string :body

      t.string :label
      t.string :link

      t.timestamps
    end
  end
end
