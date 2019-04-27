module Mutations
  class SendSurpriseEmail < Mutations::BaseMutation
    description 'dispatch a confirmation of email with a surprise inside'

    field :current_identity, ::Types::Identity, null: false

    def resolve
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity
      return GraphQL::ExecutionError.new('Your email was already confirmed.') if current_identity.confirmed_at.present?

      current_identity.update(
        confirmation_sent_at: Time.now,
        confirmation_token: TokenService.new(current_identity).perform
      )

      if current_identity.errors.any?
        return GraphQL::ExecutionError.new current_identity.errors.full_messages.join(', ')
      end

      AskalfredApiSchema.subscriptions.trigger('subscribeToCurrentIdentity', {}, {
        current_identity: current_identity.slice(:confirmation_sent_at, :confirmation_token)
      }, scope: current_identity.id)

      {
        current_identity: current_identity
      }
    end
  end
end
