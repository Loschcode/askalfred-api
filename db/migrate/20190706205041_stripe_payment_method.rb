class StripePaymentMethod < ActiveRecord::Migration[5.2]
  def change
    rename_column :identities, :stripe_card_id, :stripe_payment_method_id
  end
end
