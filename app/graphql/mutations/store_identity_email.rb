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

      unless CheckEmailService.new(input[:email]).perform
        return GraphQL::ExecutionError.new('Your email doesn\'t seem delivrable.')
      end

      current_identity.update(
        email: input[:email],
      )

      if current_identity.errors.any?
        return GraphQL::ExecutionError.new current_identity.errors.full_messages.join(', ')
      end

      refresh_service.myself

      mixpanel_service.alias(current_identity.email)
      mixpanel_service.identify(
        '$email': current_identity.email,
        '$first_name': current_identity.first_name,
        '$last_name': current_identity.last_name,
        '$created_at': current_identity.created_at
      )

      {
        current_identity: current_identity
      }
    end

    private

    def mixpanel_service
      @mixpanel_service ||= MixpanelService.new(current_identity)
    end
  end
end