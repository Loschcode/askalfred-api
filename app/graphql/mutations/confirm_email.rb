module Types
  class ConfirmEmailInput < Types::BaseInputObject
    description 'attributes to confirm a specific email'
    argument :confirmation_token, String, 'email confirmation token', required: true
  end
end

module Mutations
  class ConfirmEmail < Mutations::BaseMutation
    description 'store the first and last name within the getting started'

    argument :input, Types::ConfirmEmailInput, required: true
    field :identity, ::Types::Identity, null: false

    def resolve(input:)
      identity = Identity.find_by confirmation_token: input[:confirmation_token]
      return GraphQL::ExecutionError.new('Your identity has not been recognized. Please ask the support for a new confirmation email.') unless identity.present?
      return GraphQL::ExecutionError.new('Your email has already been confirmed') if identity.confirmed_at.present?

      identity.update(
        confirmed_at: Time.now,
        confirmation_token: nil
      )

      if identity.errors.any?
        return GraphQL::ExecutionError.new identity.errors.full_messages.join(', ')
      end

      AskalfredApiSchema.subscriptions.trigger('refreshCurrentIdentity', {}, {
        current_identity: identity
      }, scope: identity.id)

      {
        identity: identity
      }
    end
  end
end