class AddTicketsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.uuid :identity_id

      t.string :title
      t.string :subject
      t.string :status

      t.timestamps

      t.index :identity_id
      t.index :status
    end
  end
end
