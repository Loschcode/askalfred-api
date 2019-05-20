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

        event = Event.create(
          ticket: ticket,
          identity: current_identity,
          eventable: EventMessage.create(
            body: input[:message]
          )
        )

        if event.errors.any?
          raise GraphQL::ExecutionError.new event.errors.full_messages.join(', ')
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