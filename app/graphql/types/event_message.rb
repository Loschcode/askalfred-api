module Types
  class EventMessage < Types::BaseObject
    description 'event message'

    field :id, ID, null: false
    field :body, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
