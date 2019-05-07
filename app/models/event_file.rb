class EventFile < ActiveRecord::Base
  has_one :event, as: :eventable
  # as_many :events, as: :eventable

  validates :url, presence: true
end
