module Types
  class EventDataCollectionForm < Types::BaseObject
    field :id, ID, null: false

    field :body, String, null: false
    field :data_collections, [Types::DataCollection], null: false

    field :sent_at, GraphQL::Types::ISO8601DateTime, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :event, Types::Event, null: false
  end
end

