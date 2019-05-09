module Types
  class TicketsListInput < Types::BaseInputObject
    description 'attributes to show the tickets list'
    argument :limit, Integer, 'limit of the list', required: false
  end
end

module Queries
  class TicketsList < Queries::BaseQuery
    type Types::TicketsList, null: true
    description 'Get the tickets list'

    argument :input, Types::TicketsListInput, required: false

    def resolve(input: { limit: 0 })
      items = current_identity.tickets.limit(input[:limit])
      page_info = {
        total_count: current_identity.tickets.count,
        has_next_page: (items.size < current_identity.tickets.count),
        has_previous_page: false
      }

      {
        items: items,
        page_info: page_info
      }
    end
  end
end