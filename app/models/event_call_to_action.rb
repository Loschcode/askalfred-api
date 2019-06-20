class EventCallToAction < ActiveRecord::Base
  has_one :event, as: :eventable
  accepts_nested_attributes_for :event

  validates :body, presence: true, allow_blank: false

  validates :link, presence: true, allow_blank: false
  validates :label, presence: true, allow_blank: false
end
