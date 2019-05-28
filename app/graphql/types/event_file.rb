module Types
  class EventFile < Types::BaseObject
    field :id, ID, null: false
    field :file_path, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :event, Types::Event, null: false
  end
end

