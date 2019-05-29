class Event < ActiveRecord::Base
  belongs_to :eventable, polymorphic: true, required: true

  belongs_to :identity, required: true, touch: true
  belongs_to :ticket, required: true, touch: true

  scope :messages, -> { where(eventable_type: 'EventMessage') }
  scope :files, -> { where(eventable_type: 'EventFile') }

  has_one :self_ref, class_name: 'Event', foreign_key: :id
  has_one :event_message, through: :self_ref, source: :eventable, source_type: 'EventMessage', dependent: :destroy
  has_one :event_file, through: :self_ref, source: :eventable, source_type: 'EventFile', dependent: :destroy

  accepts_nested_attributes_for :event_message
  accepts_nested_attributes_for :event_file

  validates :seen_at, required: false
end
