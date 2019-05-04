module Types
  class SendRecoveryEmailInput < Types::BaseInputObject
    description 'attributes to send a recovery to a specific email'
    argument :email, String, 'email', required: true
  end
end

module Mutations
  class SendRecoveryEmail < Mutations::BaseMutation
    description 'reset the password '

    argument :input, Types::SendRecoveryEmailInput, required: true
    field :current_identity, ::Types::Identity, null: false

    def resolve(input:)
      identity = Identity.find_by email: input[:email]
      return GraphQL::ExecutionError.new('Your email was not found') unless identity.present?

      identity.update(
        recovery_sent_at: Time.now,
        recovery_token: TokenService.new(identity).perform
      )

      if identity.errors.any?
        return GraphQL::ExecutionError.new identity.errors.full_messages.join(', ')
      end

      IdentityMailer.with(identity: identity).recovery_email.deliver_later

      AskalfredApiSchema.subscriptions.trigger('subscribeToCurrentIdentity', {}, {
        current_identity: current_identity
      }, scope: current_identity.id)

      {
        current_identity: identity
      }
    end
  end
end
