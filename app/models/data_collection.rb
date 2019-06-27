class DataCollection < ActiveRecord::Base
  validates :identity_id, presence: true
  validates :ticket_id, presence: false

  validates :slug, presence: true, allow_blank: false
  validates :value, presence: true, allow_blank: false

  belongs_to :identity, touch: true
  belongs_to :ticket, optional: true, touch: true
end
