class Ticket < ActiveRecord::Base
  validates :identity_id, presence: true

  validates :title, presence: false
  validates :status, presence: true, inclusion: { in: %w(opened processing completed canceled) }

  belongs_to :identity
  has_one :credit

  has_many :events
  has_many :event_messages, through: :events
  has_many :events_files, through: :events
end
