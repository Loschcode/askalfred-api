module Mutations
  class SendSurpriseEmail < Mutations::BaseMutation
    description 'dispatch a confirmation of email with a surprise inside'

    field :current_identity, ::Types::Identity, null: false

    def resolve
      return unless current_identity

      current_identity.update!(
        confirmation_sent_at: Time.now,
        confirmation_token: TokenService.new(current_identity).perform
      )

      IdentityMailer.with(identity: current_identity).surprise_email.deliver_later

      {
        current_identity: current_identity
      }
    end
  end
end
