module Mutations
  class CreateGuest < Mutations::BaseMutation
    description 'creates a guest identity'

    field :token, String, null: true

    def resolve
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      {
        token: user.token
      }
    end

    private

    def user
      @user ||= Identity.create!(role: 'guest')
    end
  end
end
