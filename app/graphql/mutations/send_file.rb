module Types
  class SendFileInput < Types::BaseInputObject
    description 'send a message to a ticket'
    argument :id, ID, required: true
    argument :file, ApolloUploadServer::Upload, required: true
  end
end

module Mutations
  class SendFile < Mutations::BaseMutation
    description 'send a message to a specific ticket'

    argument :input, Types::SendFileInput, required: true
    field :ticket, Types::Ticket, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      ActiveRecord::Base.transaction do
        ticket = Ticket.find(input[:id])

        event_file = EventFile.create
        event_file.file.attach(input[:file])

        unless event_file.file.attached?
          raise GraphQL::ExecutionError.new 'We could not store this file.'
        end

        event = Event.create(
          ticket: ticket,
          identity: current_identity,
          eventable: event_file
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