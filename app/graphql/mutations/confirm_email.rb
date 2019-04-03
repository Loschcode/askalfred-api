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
    field :current_identity, ::Types::Identity, null: false

    def resolve(input:)
      identity = Identity.find_by! confirmation_token: input[:confirmation_token]

      if identity.confirmed_at.present?
        raise ActiveRecord::RecordInvalid, 'Your email has already been confirmed'
      end

      identity.update!(
        confirmed_at: Time.now
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