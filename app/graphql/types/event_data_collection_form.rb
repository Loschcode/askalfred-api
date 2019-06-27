module Types
  class LineItem < Types::BaseObject
    field :label, String, null: false
    field :slug, Integer, null: false
    field :value, Integer, null: true
  end
end

module Types
  class EventDataCollectionForm < Types::BaseObject
    field :id, ID, null: false

    field :body, String, null: false
    field :line_items, [Types::LineItem], null: false

    field :sent_at, GraphQL::Types::ISO8601DateTime, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :event, Types::Event, null: false
  end
end

