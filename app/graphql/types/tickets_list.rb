module Types
  class TicketsList < Types::BaseObject
    description 'tickets list'

    field :items, [Types::Ticket], null: true
    field :page_info, Types::PageInfo, null: true
  end
end