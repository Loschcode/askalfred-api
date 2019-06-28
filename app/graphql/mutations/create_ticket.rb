module Types
  class CreateTicketInput < Types::BaseInputObject
    description 'the create ticket input needs a message'
    argument :subject, String, 'subject', required: true
  end
end

module Mutations
  class CreateTicket < Mutations::BaseMutation
    MINIMUM_TIME_REQUIRED = 60 * 5 # seconds

    description 'store the first and last name within the getting started'

    argument :input, Types::CreateTicketInput, required: true
    field :tickets_connection, Types::TicketsConnection, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      if current_identity.credits.sum(:time) < MINIMUM_TIME_REQUIRED
        raise GraphQL::ExecutionError.new 'You don\'t have enough time left.', options: { type: :credits_issue }
      end

      ActiveRecord::Base.transaction do
        ticket = Ticket.create(
          identity: current_identity,
          subject: input[:subject]
        )

        if ticket.errors.any?
          raise GraphQL::ExecutionError.new ticket.errors.full_messages.join(', ')
        end

        tracking_service.new_ticket(ticket)
        refresh_service.tickets_list

        {
          tickets_connection: current_identity.tickets.order(created_at: :desc)
        }
      end
    end
  end
end