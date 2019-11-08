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

      tracking_service.track(input[:method], input[:event].permit!)

      {
        success: true
      }
    end
  end
end