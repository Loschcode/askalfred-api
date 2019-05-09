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
    field :ticket, ::Types::Ticket, null: false

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
          body: input[:message]
        )

        if event_message.errors.any?
          raise GraphQL::ExecutionError.new event_message.errors.full_messages.join(', ')
        end

        event = Event.create(
          ticket: ticket,
          identity: current_identity,
          eventable: event_message
        )

        if event.errors.any?
          raise GraphQL::ExecutionError.new event.errors.full_messages.join(', ')
        end

        {
          ticket: ticket
        }
      end
    end
  end
end