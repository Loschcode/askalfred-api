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

      origin = input[:origin].permit!.to_h

      attributes = {
        role: 'guest',
        origin: origin,
        city: '',
        country: '',
        region: '',
        timezone: '',
        ip: current_request.remote_ip,
        user_agent: current_request.user_agent
      }

      identity = Identity.create!(attributes)

      {
        token: identity.token
      }
    end
  end
end
