module Types
  class CreateTicketInput < Types::BaseInputObject
    description 'the create ticket input needs a message'
    argument :message, String, 'message', required: true
  end
end

module Mutations
  class CreateTicket < Mutations::BaseMutation
    description 'store the first and last name within the getting started'

    argument :input, Types::CreateTicketInput, required: true
    field :tickets_connection, Types::TicketsConnection, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      ActiveRecord::Base.transaction do
        ticket = Ticket.create(
          identity: current_identity,
          status: 'opened'
        )

        if ticket.errors.any?
          raise GraphQL::ExecutionError.new ticket.errors.full_messages.join(', ')
        end

        event_message = EventMessage.create(
          body: input[:message],
          event: Event.create(
            ticket: ticket,
            identity: current_identity
          )
        )

        if event_message.errors.any?
          raise GraphQL::ExecutionError.new event_message.errors.full_messages.join(', ')
        end

        {
          tickets_connection: [ticket]
        }.tap do |payload|
          AskalfredApiSchema.subscriptions.trigger('subscribeToTickets', {}, payload, scope: current_identity.id)
        end
      end
    end
  end
end