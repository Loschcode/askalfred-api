class EventDataCollectionForm < ActiveRecord::Base
  has_one :event, as: :eventable
  accepts_nested_attributes_for :event

  validates :body, presence: true, allow_blank: false

  # [{ label: 'Yo', slug: 'yo', value: 'Hello'}]
  validates :line_items, presence: true

  validates :sent_at, presence: false

  def line_items
    attributes['line_items'].map do |item|
      OpenStruct.new(item)
    end
  end
end
