class EventPaymentAuthorization < ActiveRecord::Base
  has_one :event, as: :eventable
  accepts_nested_attributes_for :event

  validates :body, presence: true, allow_blank: false

  # [{ label: '', amount_in_cents: 0.0}]
  validates :line_items, presence: true
  validates :fees_in_cents, presence: true

  validates :authorized_at, presence: false
  validates :stripe_charge_id, presence: false

  def line_items
    attributes['line_items'].map do |item|
      OpenStruct.new(item)
    end
  end

  def amount_in_cents
    line_items.sum(&:amount_in_cents)
  end

  def total_in_cents
    amount_in_cents + fees_in_cents
  end
end
