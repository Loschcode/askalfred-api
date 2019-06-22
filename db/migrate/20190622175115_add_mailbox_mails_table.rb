class AddMailboxMailsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :mailbox_mails, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.uuid :identity_id
      t.uuid :ticket_id

      t.string :direction

      t.string :subject
      t.string :from
      t.string :to
      t.string :body
      t.jsonb :raw

      t.timestamps

      t.index :identity_id
      t.index :ticket_id
      t.index [:identity_id, :ticket_id]
      t.index [:identity_id, :direction]
      t.index [:ticket_id, :direction]
    end
  end
end
