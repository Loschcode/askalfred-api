module Types
  class UnsetPasswordInput < Types::BaseInputObject
    description 'attributes to confirm a specific email'
    argument :recovery_token, String, 'email confirmation token', required: true
  end
end

module Mutations
  class UnsetPassword < Mutations::BaseMutation
    description 'store the first and last name within the getting started'

    argument :input, Types::UnsetPasswordInput, required: true
    field :current_identity, ::Types::Identity, null: false

    def resolve(input:)
      identity = Identity.find_by recovery_token: input[:recovery_token]
      return GraphQL::ExecutionError.new('Your identity has not been recognized') unless identity.present?

      identity.update!(
        encrypted_password: nil
      )

      AskalfredApiSchema.subscriptions.trigger('subscribeToCurrentIdentity', {}, {
        current_identity: identity
      }, scope: identity.id)

      {
        current_identity: identity
      }
    end
  end
end