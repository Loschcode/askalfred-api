require 'bcrypt'

module Types
  class SignInInput < Types::BaseInputObject
    description 'attributes to sign-in'
    argument :email, String, 'email', required: true
    argument :password, String, 'password', required: true
  end
end

module Mutations
  class SignIn < Mutations::BaseMutation
    description 'try to sign-in'

    argument :input, Types::SignInInput, required: true
    field :token, String, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      identity = Identity.find_by(email: input[:email])

      unless identity.present?
        return GraphQL::ExecutionError.new 'Your email has not been recognized.'
      end

      unless BCrypt::Password.new(identity.encrypted_password) == input[:password]
        return GraphQL::ExecutionError.new 'Your email / password does not match.'
      end

      # for now we just wipe out the guest
      current_identity.destroy

      AskalfredApiSchema.subscriptions.trigger('subscribeToCurrentIdentity', {}, {
        current_identity: identity
      }, scope: identity.id)

      {
        token: identity.token
      }
    end

    private
  end
end