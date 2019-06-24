module Types
  class EventPaymentAuthorization < Types::BaseObject
    field :id, ID, null: false

    field :body, String, null: false

    field :amount_in_cents, String, null: false
    field :fees_in_cents, String, null: false

    field :authorized_at, GraphQL::Types::ISO8601DateTime, null: false

    field :stripe_charge_id, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :event, Types::Event, null: false
  end
end
