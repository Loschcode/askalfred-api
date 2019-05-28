class Ticket < ActiveRecord::Base
  validates :identity_id, presence: true

  validates :title, presence: false
  validates :status, presence: true, inclusion: { in: %w(opened processing completed canceled) }

  enum status: {
    opened: 'opened',
    processing: 'processing',
    completed: 'completed',
    canceled: 'canceled'
  }

  belongs_to :identity
  has_one :credit

  has_many :events
  accepts_nested_attributes_for :events, reject_if: :all_blank, allow_destroy: true
  validates_associated :events

  has_many :event_messages, through: :events
  has_many :events_files, through: :events
end
