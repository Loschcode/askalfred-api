class ChangeColumnStripeChargeToStripeIntent < ActiveRecord::Migration[5.2]
  def change
    rename_column :credits, :stripe_charge_id, :stripe_intent_id
  end
end
