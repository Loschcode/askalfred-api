class Event < ActiveRecord::Base
  belongs_to :eventable, polymorphic: true, required: true

  belongs_to :identity, required: true, touch: true
  belongs_to :ticket, required: true, touch: true

  scope :messages, -> { where(eventable_type: 'EventMessage') }
  scope :files, -> { where(eventable_type: 'EventFile') }

  has_one :self_ref, class_name: 'Event', foreign_key: :id
  has_one :event_message, through: :self_ref, source: :eventable, source_type: 'EventMessage'
  has_one :event_call_to_action, through: :self_ref, source: :eventable, source_type: 'EventCallToAction'
  has_one :event_file, through: :self_ref, source: :eventable, source_type: 'EventFile'

  accepts_nested_attributes_for :event_message
  accepts_nested_attributes_for :event_call_to_action
  accepts_nested_attributes_for :event_file

  validates :seen_at, required: false

  before_destroy :destroy_related_events

  # simple destroy dependency doesn't work with
  # has_one on this kind relationship
  # so we do it manually here
  def destroy_related_events
    event_message.destroy if event_message
    event_file.destroy if event_file
  end
end
