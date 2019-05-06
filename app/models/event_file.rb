class EventFile < ActiveRecord::Base
  has_many :events, as: :eventable

  validates :url, presence: true
end
