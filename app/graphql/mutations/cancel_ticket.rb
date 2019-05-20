module Types
  class CancelTicketInput < Types::BaseInputObject
    description 'the cancel a ticket'
    argument :id, ID, required: true
  end
end

module Mutations
  class CancelTicket < Mutations::BaseMutation
    CANCELABLE_STATUS = ['opened', 'processing'].freeze

    description 'store the first and last name within the getting started'

    argument :input, Types::CancelTicketInput, required: true
    field :ticket, Types::Ticket, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      ActiveRecord::Base.transaction do
        ticket = Ticket.find(input[:id])

        # TODO : maybe move into validations in model?
        unless CANCELABLE_STATUS.include? ticket.status
          raise GraphQL::ExecutionError.new 'You can\'t cancel this ticket'
        end

        ticket.update status: 'canceled'

        if ticket.errors.any?
          raise GraphQL::ExecutionError.new ticket.errors.full_messages.join(', ')
        end

        AskalfredApiSchema.subscriptions.trigger('refreshTicket', {
          id: ticket.id
        }, {
          ticket: ticket
        }, scope: current_identity.id)

        {
          ticket: ticket
        }
      end
    end
  end
end