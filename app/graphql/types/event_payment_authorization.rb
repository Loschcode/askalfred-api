module Types
  class EventPaymentAuthorization < Types::BaseObject
    field :id, ID, null: false

    field :body, String, null: false
    field :line_item, String, null: false

    field :amount_in_cents, Integer, null: false
    field :fees_in_cents, Integer, null: false

    field :authorized_at, GraphQL::Types::ISO8601DateTime, null: true
    field :stripe_charge_id, String, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :event, Types::Event, null: false
  end
end
