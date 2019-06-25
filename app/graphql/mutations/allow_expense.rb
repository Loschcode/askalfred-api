module Types
  class AllowExpenseInput < Types::BaseInputObject
    description 'allow expense (event EventPaymentAuthorization)'
    argument :event_id, ID, required: true
  end
end

module Mutations
  class AllowExpense < Mutations::BaseMutation
    argument :input, Types::AllowExpenseInput, required: true
    field :success, Boolean, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      ActiveRecord::Base.transaction do
        event = Event.find(input[:event_id])
        payment_authorization = event.eventable
        ticket = event.ticket

        payment_authorization.update authorized_at: Time.now

        if payment_authorization.errors.any?
          raise GraphQL::ExecutionError.new payment_authorization.errors.full_messages.join(', ')
        end

        refresh_service.ticket(ticket)

        {
          success: true
        }
      end
    end
  end
end