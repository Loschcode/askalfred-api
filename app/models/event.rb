class Event < ActiveRecord::Base
  belongs_to :eventable, polymorphic: true

  validates :identity_id, presence: true
  validates :ticket_id, presence: true

  belongs_to :identity
  belongs_to :ticket

  # NOPE:
  # has_one :self_ref, class_name: 'Event', foreign_key: :id
  # has_one :event_message, through: :self_ref, source: :eventable, source_type: 'EventMessage'
  # has_one :event_file, through: :self_ref, source: :eventable, source_type: 'EventFile'

  # NOPE:
  # has_one :event_message, as: :eventable
  # has_one :event_file, as: :eventable
end
