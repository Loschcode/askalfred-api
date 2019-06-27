class AddEventPaymentAuthorizationsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :event_payment_authorizations, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string :body

      t.jsonb :line_items, default: '[]'
      t.integer :fees_in_cents

      t.datetime :authorized_at

      t.string :stripe_charge_id

      t.timestamps

      t.index :stripe_charge_id
      t.index :authorized_at
    end
  end
end
