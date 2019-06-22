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

  belongs_to :identity, touch: true
  has_many :credits, dependent: :destroy
  has_many :mailbox_mails, dependent: :destroy

  has_many :events, dependent: :destroy
  accepts_nested_attributes_for :events, reject_if: :all_blank, allow_destroy: true
  validates_associated :events

  has_many :event_messages, through: :events, source: :eventable, source_type: 'EventMessage'
  has_many :event_files, through: :events, source: :eventable, source_type: 'EventFile'
end
