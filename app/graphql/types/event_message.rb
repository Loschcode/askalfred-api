module Types
  class EventMessageInput < Types::BaseInputObject
    description 'event message arguments'
    argument :limit, Integer, 'limit of the messages', required: false
  end
end

module Types
  class EventMessage < Types::BaseObject
    description 'event message'

    field :id, ID, null: false

    field :body, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
