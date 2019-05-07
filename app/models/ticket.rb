class Ticket < ActiveRecord::Base
  validates :identity_id, presence: true

  validates :title, presence: false
  validates :status, presence: true, inclusion: { in: %w(opened processing completed canceled) }

  belongs_to :identity
  has_one :credit
  has_many :events

  def event_messages
    events.messages
  end

  def event_files
    events.files
  end
end
