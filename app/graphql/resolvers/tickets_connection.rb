module Resolvers
  class TicketsConnection < Resolvers::BaseResolver
    type Types::Ticket.connection_type, null: false

    def resolve
      current_identity.tickets
    end
  end
end
