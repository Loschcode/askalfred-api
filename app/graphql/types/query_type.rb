module Types
  class QueryType < Types::BaseObject
    extend ActiveSupport::Concern

    field :currentIdentity, resolver: Queries::CurrentIdentity
    field :ticketsList, resolver: Queries::TicketsList
  end
end