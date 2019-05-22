class EventFile < ActiveRecord::Base
  has_one :event, as: :eventable
  accepts_nested_attributes_for :event

  has_one_attached :file
end
