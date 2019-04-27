module Types
  class StoreIdentityNameInput < Types::BaseInputObject
    description 'attributes to update the store identity name'
    argument :first_name, String, 'first name', required: true
    argument :last_name, String, 'last name ', required: true
  end
end

module Mutations
  class StoreIdentityName < Mutations::BaseMutation
    description 'store the first and last name within the getting started'

    argument :input, Types::StoreIdentityNameInput, required: true
    field :first_name, String, null: true
    field :last_name, String, null: true

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      current_identity.update(
        first_name: input[:first_name],
        last_name: input[:last_name]
      )

      if current_identity.errors.any?
        return GraphQL::ExecutionError.new current_identity.errors.full_messages.join(', ')
      end

      AskalfredApiSchema.subscriptions.trigger('subscribeToCurrentIdentity', {}, {
        current_identity: current_identity.slice(:first_name, :last_name)
      }, scope: current_identity.id)

      current_identity.slice(:first_name, :last_name)
    end

    private
  end
end