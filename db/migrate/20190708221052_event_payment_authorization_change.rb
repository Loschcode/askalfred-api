class EventPaymentAuthorizationChange < ActiveRecord::Migration[5.2]
  def change
    rename_column :event_payment_authorizations, :stripe_charge_id, :stripe_payment_intent_id
    # rename_column :credits, :stripe_intent_id, :stripe_payment_intent_id
  end
end
