class EventDataCollectionForm < ActiveRecord::Base
  has_one :event, as: :eventable
  accepts_nested_attributes_for :event

  validates :body, presence: true, allow_blank: false

  has_many :data_collection_form_items, dependent: :destroy
  has_many :data_collections, through: :data_collection_form_items

  validates :sent_at, presence: false
end
