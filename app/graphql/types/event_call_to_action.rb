module Types
  class EventCallToAction < Types::BaseObject
    field :id, ID, null: false

    field :body, String, null: false

    field :link, String, null: false
    field :label, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :event, Types::Event, null: false
  end
end

