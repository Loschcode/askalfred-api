class Event < ActiveRecord::Base
  belongs_to :eventable, polymorphic: true, required: true

  belongs_to :identity, required: true
  belongs_to :ticket, required: true

  scope :messages, -> { where(eventable_type: 'EventMessage') }
  scope :files, -> { where(eventable_type: 'EventFile') }

  has_one :self_ref, class_name: 'Event', foreign_key: :id
  has_one :event_message, through: :self_ref, source: :eventable, source_type: 'EventMessage'
  has_one :event_file, through: :self_ref, source: :eventable, source_type: 'EventFile'

  accepts_nested_attributes_for :event_message
  accepts_nested_attributes_for :event_file
  validates_associated :event_message
  validates_associated :event_file
end
