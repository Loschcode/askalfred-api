require 'bcrypt'

module Types
  class TrackActionInput < Types::BaseInputObject
    description 'attributes to sign-in'
    argument :action, String, 'action', required: true
  end
end

module Mutations
  class TrackAction < Mutations::BaseMutation
    description 'track the identity action'

    argument :input, Types::TrackActionInput, required: true

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      # TODO : here you use the TrackingService to trigger the action and shit

      {}
    end

    private
  end
end