module Mutations
  class ConvertGuestToCustomer < Mutations::BaseMutation
    REQUIRED_FIELDS = [:email, :encrypted_password, :first_name, :last_name].freeze

    description 'dispatch a confirmation of email with a surprise inside'

    field :current_identity, ::Types::Identity, null: false

    def resolve
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity
      return GraphQL::ExecutionError.new('You are already a customer.') if current_identity.role === 'customer'
      return GraphQL::ExecutionError.new('Your profile was not completed correctly. Please contact support.') unless required_fields_present?

      current_identity.update(
        role: 'customer'
      )

      if current_identity.errors.any?
        return GraphQL::ExecutionError.new identity.errors.full_messages.join(', ')
      end

      refresh_service.myself

      {
        current_identity: current_identity
      }
    end

    def required_fields_present?
      current_identity.slice(REQUIRED_FIELDS).compact.size == REQUIRED_FIELDS.size
    end
  end
end
