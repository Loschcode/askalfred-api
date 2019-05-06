class Event < ActiveRecord::Base
  belongs_to :eventable, polymorphic: true

  validates :identity_id, presence: true
  validates :ticket_id, presence: true

  belongs_to :identity
  belongs_to :ticket
end
