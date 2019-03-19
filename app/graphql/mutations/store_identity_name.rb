# TODO : maybe move this elsewhere ? Or maybe not who knows.
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
      return unless current_identity

      current_identity.update!(
        first_name: input[:first_name],
        last_name: input[:last_name]
      )

      changeset = {
        current_identity: {
          first_name: current_identity.first_name,
          last_name: current_identity.last_name
        }
      }

      AskalfredApiSchema.subscriptions.trigger('subscribeToCurrentIdentity', {}, changeset, scope: current_identity.id)

      changeset
    end

    private

    def user
      @user ||= Identity.create!(role: 'guest')
    end
  end
end