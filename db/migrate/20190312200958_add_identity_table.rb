class AddIdentityTable < ActiveRecord::Migration[5.2]
  def change
    create_table :identities, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string :role
      t.string :email
      t.string :encrypted_password
      t.string :first_name
      t.string :last_name
      t.string :token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :confirmation_token

      t.timestamps

      t.index :email
      t.index :encrypted_password
      t.index [:email, :encrypted_password]
      t.index :confirmed_at
      t.index :confirmation_sent_at
      t.index :confirmation_token
    end
  end
end
