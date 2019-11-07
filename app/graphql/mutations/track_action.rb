require 'bcrypt'

module Types
  class TrackActionInput < Types::BaseInputObject
    argument :method, String, 'method', required: true
    argument :event, GraphQL::Types::JSON, 'event', required: true
  end
end

module Mutations
  class TrackAction < Mutations::BaseMutation
    description 'track the identity event'

    argument :input, Types::TrackActionInput, required: true
    field :success, Boolean, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      mixpanel_service.track(input[:method], input[:event].permit!)

      {
        success: true
      }
    end

    private

    def mixpanel_service
      @mixpanel_service ||= MixpanelService.new(current_identity)
    end

  end
end