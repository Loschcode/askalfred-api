class EventMessage < ActiveRecord::Base
  has_one :event, as: :eventable
  accepts_nested_attributes_for :event

  validates :body, presence: true, allow_blank: false
  # this checks for printable character which's way better
  validates_format_of :body, :with => /\A[[:graph:]]\Z/i
end
