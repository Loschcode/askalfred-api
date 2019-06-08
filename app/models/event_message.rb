class EventMessage < ActiveRecord::Base
  belongs_to :event, -> { where(events: {eventable_type: 'EventMessage'}) }, foreign_key: 'eventable_id'
  # has_one :event, as: :eventable
  accepts_nested_attributes_for :event

  validates :body, presence: true, allow_blank: false
end
