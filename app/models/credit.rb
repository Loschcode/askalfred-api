class Credit < ActiveRecord::Base
  validates :time, presence: true
  validates :identity_id, presence: true
  validates :ticket_id, presence: false

  validates :origin, presence: true, inclusion: {
    in: %w(registration_bonus charge_customer time_consumed_on_ticket)
  }

  enum origin: {
    registration_bonus: 'registration_bonus',
    charge_customer: 'charge_customer',
    time_consumed_on_ticket: 'time_consumed_on_ticket'
  }

  validates :stripe_charge_id, presence: false

  belongs_to :identity, counter_cache: true, touch: true
  belongs_to :ticket, optional: true, touch: true
end
