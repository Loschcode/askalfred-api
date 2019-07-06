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
      t.datetime :recovery_sent_at
      t.datetime :terms_accepted_at
      t.string :confirmation_token
      t.string :recovery_token
      t.integer :credits_count, default: 0

      t.string :stripe_customer_id
      t.string :stripe_payment_method_id

      t.datetime :email_opt_out_at

      t.timestamps

      t.index :email
      t.index :encrypted_password
      t.index [:email, :encrypted_password]
      t.index :confirmed_at
      t.index :confirmation_sent_at
      t.index :confirmation_token
      t.index :recovery_sent_at
      t.index :terms_accepted_at
      t.index :recovery_token
      t.index :credits_count
      t.index :stripe_customer_id
      t.index :stripe_payment_method_id
      t.index :email_opt_out_at
    end
  end
end
