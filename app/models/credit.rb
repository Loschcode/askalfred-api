class Credit < ActiveRecord::Base
  validates :time, presence: true
  validates :identity_id, presence: true
  validates :ticket_id, presence: false

  belongs_to :identity
  belongs_to :ticket
end
