class AddEventPaymentAuthorizationsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :event_payment_authorizations, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string :body

      t.integer :amount_in_cents
      t.integer :fees_in_cents

      t.datetime :authorized_at

      t.string :stripe_charge_id

      t.timestamps
    end
  end
end
