class Credit < ActiveRecord::Base
  validates :time, presence: true
  validates :identity_id, presence: true
  validates :ticket_id, presence: false

  validates :origin, presence: true, inclusion: { in: %w(registration_bonus) }

  belongs_to :identity
  belongs_to :ticket, optional: true
end
