module Mutations
  class CreateAnonymousUser < Mutations::BaseMutation
    field :token, String, null: true

    def resolve
      return if current_user

      {
        token: user.token
      }
    end

    private

    def user
      @user ||= User.create!(role: 'anonymous')
    end
  end
end
