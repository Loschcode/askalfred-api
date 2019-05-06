class Event < ActiveRecord::Base
  belongs_to :eventable, polymorphic: true

  validates :identity_id, presence: true
  validates :thread_id, presence: false

  belongs_to :identity
  belongs_to :thread
end
