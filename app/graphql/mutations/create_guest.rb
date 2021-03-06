module Types
  class CreateGuestInput < Types::BaseInputObject
    argument :origin, GraphQL::Types::JSON, 'origin', required: false
  end
end

module Mutations
  class CreateGuest < Mutations::BaseMutation
    description 'creates a guest identity'

    argument :input, Types::CreateGuestInput, required: true

    field :token, String, null: true

    def resolve(input:)
      return GraphQL::ExecutionError.new('We cannot create a guest as you already have an identity') if current_identity

      identity = CreateGuestService.new(current_request, input).perform

      {
        token: identity.token
      }
    end
  end
end
