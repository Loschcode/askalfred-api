class AddIdentityTable < ActiveRecord::Migration[5.2]
  def change
    create_table :identities, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string :role
      t.string :email
      t.string :encrypted_password
      t.string :first_name
      t.string :last_name
      t.string :token
      t.timestamps

      t.index :email
      t.index :encrypted_password
      t.index [:email, :encrypted_password]
    end
  end
end