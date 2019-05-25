class Credit < ActiveRecord::Base
  validates :time, presence: true
  validates :identity_id, presence: true
  validates :ticket_id, presence: false

  validates :origin, presence: true, inclusion: {
    in: %w(registration_bonus charge_customer)
  }

  validates :stripe_charge_id, presence: false

  belongs_to :identity, counter_cache: true
  belongs_to :ticket, optional: true
end
