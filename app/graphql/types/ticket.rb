module Types
  class Ticket < Types::BaseObject
    description 'ticket'

    field :id, ID, null: false

    field :identity, Types::Identity, null: false
    field :title, String, null: false
    field :status, String, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :messages, [Types::EventMessage], null: true do
      argument :input, Types::EventMessageInput, required: false
    end

    def messages(input: {})
      messages = object.event_messages
      messages = messages.limit(input[:limit]) if input[:limit].present?
      messages
    end
  end
end
