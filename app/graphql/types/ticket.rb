module Types
  class Ticket < Types::BaseObject
    description 'ticket'

    field :id, ID, null: false

    field :identity, Types::Identity, null: false
    field :title, String, null: true
    field :status, String, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :messages, [Types::EventMessage], null: true
    def messages
      object.event_messages
    end

    field :messages_connection, Types::EventMessage.connection_type, null: true
    def messages_connection
      object.event_messages
    end
  end
end
