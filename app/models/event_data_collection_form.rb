class EventDataCollectionForm < ActiveRecord::Base
  has_one :event, as: :eventable
  accepts_nested_attributes_for :event

  has_many :data_collection_form_items, dependent: :destroy
  has_many :data_collections, through: :data_collection_form_items

  validates :body, presence: true, allow_blank: false

  validates :sent_at, presence: false
end
