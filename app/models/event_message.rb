class EventMessage < ActiveRecord::Base
  has_one :event, as: :eventable, required: true
  accepts_nested_attributes_for :event

  validates :body, presence: true
end
