module Types
  class DeleteGuestInput < Types::BaseInputObject
    description 'attributes to delete a guest'
    argument :token, String, 'email confirmation token', required: true
  end
end

module Mutations
  class DeleteGuest < Mutations::BaseMutation
    description 'delete a specific guest from its token'

    argument :input, Types::DeleteGuestInput, required: true
    field :identity, ::Types::Identity, null: false

    def resolve(input:)
      identity = Identity.find_by token: input[:token]

      return GraphQL::ExecutionError.new('Identity to delete not recognized') unless identity.present?
      return GraphQL::ExecutionError.new('You cannot delete an identity which is not a guest') unless identity.guest?

      TrackingService.new(identity).identity_removed
      identity.destroy

      {
        identity: identity
      }
    end
  end
end