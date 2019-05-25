module Types
  class Identity < Types::BaseObject
    description 'identity'

    field :id, ID, null: false

    field :token, String, null: false
    field :role, String, null: false

    field :email, String, null: true
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :encrypted_password, String, null: true

    field :confirmed_at, GraphQL::Types::ISO8601DateTime, null: true
    field :confirmation_sent_at, GraphQL::Types::ISO8601DateTime, null: true
    field :confirmation_token, String, null: true

    field :recovery_sent_at, GraphQL::Types::ISO8601DateTime, null: true
    field :recovery_token, String, null: true

    field :stripe_customer_id, String, null: true
    field :stripe_card_id, String, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :creditsCount, Integer, null: false
  end
end
