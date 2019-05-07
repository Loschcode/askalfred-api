class Event < ActiveRecord::Base
  belongs_to :eventable, polymorphic: true

  validates :identity_id, presence: true
  validates :ticket_id, presence: true

  belongs_to :identity
  belongs_to :ticket

  scope :messages, -> { where(eventable_type: 'EventMessage') }
  scope :files, -> { where(eventable_type: 'EventFile') }

  has_one :self_ref, class_name: 'Event', foreign_key: :id
  has_one :event_message, through: :self_ref, source: :eventable, source_type: 'EventMessage'
  has_one :event_file, through: :self_ref, source: :eventable, source_type: 'EventFile'
end
