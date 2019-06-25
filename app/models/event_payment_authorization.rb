class EventPaymentAuthorization < ActiveRecord::Base
  has_one :event, as: :eventable
  accepts_nested_attributes_for :event

  validates :body, presence: true, allow_blank: false
  validates :line_item, presence: true, allow_blank: false

  validates :amount_in_cents, presence: true
  validates :fees_in_cents, presence: true

  validates :authorized_at, presence: false
  validates :stripe_charge_id, presence: false

  def total_in_cents
    amount_in_cents + fees_in_cents
  end
end