module Types
  class SendMessageInput < Types::BaseInputObject
    description 'send a message to a ticket'
    argument :id, ID, required: true
    argument :message, String, required: true
  end
end

module Mutations
  class SendMessage < Mutations::BaseMutation
    description 'send a message to a specific ticket'

    argument :input, Types::SendMessageInput, required: true
    field :ticket, Types::Ticket, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      ActiveRecord::Base.transaction do
        ticket = Ticket.find(input[:id])

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

        refresh_service.ticket(ticket)

        {
          ticket: ticket
        }
      end
    end
  end
end