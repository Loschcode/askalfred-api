module Types
  class GetFullTicketInput < Types::BaseInputObject
    argument :id, ID, 'ticket id', required: true
  end
end

module Resolvers
  class GetFullTicket < Resolvers::BaseResolver
    argument :input, Types::GetFullTicketInput, required: true
    type Types::Ticket, null: false

    def resolve(input:)
      ticket = Ticket.find(input[:id])
      was_seen_tickets = ticket.events.where.not(identity: current_identity).where(seen_at: nil)

      if was_seen_tickets.any?
        was_seen_tickets.update(seen_at: Time.now)
      end

      ticket
    end
  end
end
