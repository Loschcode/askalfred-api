class Credit < ActiveRecord::Base
  validates :time, presence: true
  validates :identity_id, presence: true

  belongs_to :identity
end
