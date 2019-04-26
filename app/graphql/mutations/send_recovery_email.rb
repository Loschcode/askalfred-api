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

      identity.update!(
        recovery_sent_at: Time.now,
        recovery_token: TokenService.new(current_identity).perform
      )

      IdentityMailer.with(identity: current_identity).recovery_email.deliver_later

      AskalfredApiSchema.subscriptions.trigger('subscribeToCurrentIdentity', {}, {
        current_identity: identity
      }, scope: identity.id)

      {
        current_identity: identity
      }
    end
  end
end