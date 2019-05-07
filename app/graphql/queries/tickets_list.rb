module Queries
  class TicketsList < Queries::BaseQuery
    type [Types::Ticket], null: true
    description 'Get the tickets list'

    def resolve
      current_identity.tickets
    end
  end
end
