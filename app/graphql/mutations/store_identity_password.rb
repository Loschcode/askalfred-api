require 'bcrypt'

module Types
  class StoreIdentityPasswordInput < Types::BaseInputObject
    description 'attributes to update the identity password'
    argument :password, String, 'password', required: true
  end
end

module Mutations
  class StoreIdentityPassword < Mutations::BaseMutation
    description 'store the password'

    argument :input, Types::StoreIdentityPasswordInput, required: true
    field :current_identity, ::Types::Identity, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity
      return GraphQL::ExecutionError.new('You have already set your password') unless current_identity.encrypted_password.blank?

      password_hash = BCrypt::Password.create(input[:password])

      current_identity.update(
        encrypted_password: password_hash,
        recovery_token: nil,
      )

      if current_identity.errors.any?
        return GraphQL::ExecutionError.new current_identity.errors.full_messages.join(', ')
      end

      slack_service.signed_up
      refresh_service.myself

      {
        current_identity: current_identity
      }
    end

    private
  end
end