module Types
  class Identity < Types::BaseObject
    description "user"

    field :id, ID, null: false

    field :token, String, null: false
    field :role, String, null: false

    field :email, String, null: true
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :encrypted_password, String, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
