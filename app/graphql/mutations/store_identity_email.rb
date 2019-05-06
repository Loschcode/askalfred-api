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
    field :current_identity, ::Types::Identity, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      if current_identity.email.present? && current_identity.confirmed_at.present?
        return GraphQL::ExecutionError.new('You already confirmed your email. You can\'t change it here.')
      end

      current_identity.update(
        email: input[:email],
      )

      if current_identity.errors.any?
        return GraphQL::ExecutionError.new current_identity.errors.full_messages.join(', ')
      end

      AskalfredApiSchema.subscriptions.trigger('subscribeToCurrentIdentity', {}, {
        current_identity: current_identity
      }, scope: current_identity.id)

      {
        current_identity: current_identity
      }
    end

    private
  end
end