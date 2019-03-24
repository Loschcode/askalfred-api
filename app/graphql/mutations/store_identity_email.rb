module Types
  class StoreIdentityEmailInput < Types::BaseInputObject
    description 'attributes to update the store identity email'
    argument :email, String, ' email', required: true
  end
end

module Mutations
  class StoreIdentityEmail < Mutations::BaseMutation
    description 'store the first and last name within the getting started'

    argument :input, Types::StoreIdentityEmailInput, required: true
    field :email, String, null: true

    def resolve(input:)
      return unless current_identity

      current_identity.update!(
        email: input[:email],
      )

      AskalfredApiSchema.subscriptions.trigger('subscribeToCurrentIdentity', {}, {
        current_identity: current_identity.slice(:email)
      }, scope: current_identity.id)

      current_identity.slice(:email)
    end

    private
  end
end