module Types
  class QueryType < Types::BaseObject
    extend ActiveSupport::Concern

    field :currentIdentity, resolver: Resolvers::CurrentIdentity
    # NOTE : maybe rename this, it's not a connection
    # if it's not linked to anything
    field :ticketsConnection, resolver: Resolvers::TicketsConnection
    field :getFullTicket, resolver: Resolvers::GetFullTicket
    field :getFullCredits, resolver: Resolvers::GetFullCredits
  end
end
