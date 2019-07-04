class DataCollection < ActiveRecord::Base
  validates :identity_id, presence: true
  validates :ticket_id, presence: false

  validates :label, presence: true, allow_blank: false
  validates :slug, presence: true, allow_blank: false
  validates :scope, presence: true, allow_blank: false # [ticket, identity]
  validates :value, presence: false

  validates :slug, uniqueness: { scope: :identity_id }

  belongs_to :identity, touch: true
  belongs_to :ticket, optional: true, touch: true

  has_many :data_collection_form_items, dependent: :destroy
end
