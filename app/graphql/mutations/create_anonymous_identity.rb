module Mutations
  class CreateAnonymousIdentity < Mutations::BaseMutation
    field :token, String, null: true

    def resolve
      return if current_identity

      {
        token: user.token
      }
    end

    private

    def user
      @user ||= Identity.create
    end
  end
end
