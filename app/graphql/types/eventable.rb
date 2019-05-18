module Types
  module Eventable
    include Types::BaseInterface

    field :id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    definition_methods do
      def resolve_type(object, context)
        if object.is_a?(::EventMessage)
          Types::EventMessage
        else
          raise "Unexpected Eventable: #{object.inspect}"
        end
      end
    end
  end
end