class Ticket < ActiveRecord::Base
  validates :identity_id, presence: true

  validates :title, presence: false

  validates :completed_at, presence: false
  validates :canceled_at, presence: false

  belongs_to :identity, touch: true
  has_many :credits, dependent: :destroy
  has_many :mailbox_mails, dependent: :destroy
  has_many :data_collections, dependent: :destroy

  has_many :events, dependent: :destroy
  accepts_nested_attributes_for :events, reject_if: :all_blank, allow_destroy: true
  validates_associated :events

  has_many :event_messages, through: :events, source: :eventable, source_type: 'EventMessage'
  has_many :event_files, through: :events, source: :eventable, source_type: 'EventFile'

  def status
    return 'canceled' if canceled_at
    return 'completed' if completed_at
    return 'processing' if any_action_taken?

    'opened'
  end

  def mailbox
    identity.mailbox.gsub('@', "+#{id}@")
  end

  private

  # if alfred did anything on this ticket it'll return true here
  # it starts with the less costy and go up to the related models
  def any_action_taken?
    return true unless title.blank?
    return true if events.from_alfred.exists?
    return true if credits.exists?
    return true if canceled_at || completed_at

    false
  end

end
