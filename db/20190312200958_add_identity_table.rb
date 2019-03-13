class AddIdentityTable < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string :role
      t.string :email
      t.string :password
      t.string :first_name
      t.string :last_name
      t.string :token
      t.timestamps

      t.index :email
      t.index :password
      t.index [:email, :password]
    end
  end
end
