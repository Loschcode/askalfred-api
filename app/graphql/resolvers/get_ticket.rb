module Types
  class GetTicketInput < Types::BaseInputObject
    argument :id, ID, 'ticket id', required: true
  end
end

module Resolvers
  class GetTicket < Resolvers::BaseResolver
    argument :input, Types::GetTicketInput, required: true
    type Types::Ticket, null: true

    def resolve(input:)
      Ticket.find(input[:id])
    end
  end
end
