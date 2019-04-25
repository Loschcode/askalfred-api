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
    field :encrypted_password, String, null: true

    def resolve(input:)
      return unless current_identity

      return GraphQL::ExecutionError.new('You have already set your password') if current_identity.encrypted_password.present?

      password_hash = BCrypt::Password.create(input[:password])
      encrypted_password = BCrypt::Password.new(password_hash)

      current_identity.update!(
        encrypted_password: encrypted_password,
      )

      AskalfredApiSchema.subscriptions.trigger('subscribeToCurrentIdentity', {}, {
        current_identity: current_identity.slice(:encrypted_password)
      }, scope: current_identity.id)

      current_identity.slice(:encrypted_password)
    end

    private
  end
end