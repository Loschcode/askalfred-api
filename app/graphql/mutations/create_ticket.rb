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
          body: input[:message],
          event: Event.create(
            ticket: ticket,
            identity: current_identity
          )
        )

        if event_message.errors.any?
          raise GraphQL::ExecutionError.new event_message.errors.full_messages.join(', ')
        end

        items = current_identity.tickets
        page_info = {
          total_count: current_identity.tickets.count,
          has_next_page: (items.size < current_identity.tickets.count),
          has_previous_page: false
        }
        AskalfredApiSchema.subscriptions.trigger('subscribeToTicketsList', {}, {
          tickets_list: {
            items: items,
            page_info: page_info
          }
        }, scope: current_identity.id)

        {
          ticket: ticket
        }
      end
    end
  end
end