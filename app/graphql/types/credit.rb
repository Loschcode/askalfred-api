module Types
  class Credit < Types::BaseObject
    description 'identity\'s credits'

    field :id, ID, null: false
    field :time, Integer, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :identity, Types::Identity, null: false
    field :ticket, Types::Ticket, null: true
  end
end
