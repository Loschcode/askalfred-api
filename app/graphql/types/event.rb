module Types
  class Event < Types::BaseObject
    field :id, ID, null: false

    field :type, String, null: true

    def type
      object.eventable_type
    end

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :eventable, Types::Eventable, null: true
  end
end