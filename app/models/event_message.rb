class EventMessage < ActiveRecord::Base
  has_one :event, as: :eventable
  # as_many :events, as: :eventable

  validates :body, presence: true
end
