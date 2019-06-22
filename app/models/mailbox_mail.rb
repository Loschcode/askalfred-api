class MailboxMail < ActiveRecord::Base
  validates :identity_id, presence: true
  validates :ticket_id, presence: false

  validates :direction, presence: true, inclusion: {
    in: %w(sent received)
  }

  enum direction: {
    sent: 'sent',
    received: 'received'
  }

  belongs_to :identity
  belongs_to :ticket, optional: true
end
