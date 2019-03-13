module Types
  class Identity < Types::BaseObject
    description "identity"

    field :id, ID, null: false

    field :token, String, null: false
    field :role, String, null: false
    field :email, String, null: false
    field :encrypted_password, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
