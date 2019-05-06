class Ticket < ActiveRecord::Base
  validates :identity_id, presence: true

  validates :title, presence: false
  validates :status, presence: true

  belongs_to :identity
  has_one :credit
  has_many :events
end
