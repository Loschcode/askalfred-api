class EventMessage < ActiveRecord::Base
  has_many :events, as: :eventable

  validates :body, presence: true
end
