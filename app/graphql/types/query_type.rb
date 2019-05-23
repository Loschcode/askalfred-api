module Types
  class QueryType < Types::BaseObject
    extend ActiveSupport::Concern

    field :currentIdentity, resolver: Resolvers::CurrentIdentity
    # NOTE : maybe rename this, it's not a connection
    # if it's not linked to anything
    field :tickets_connection, resolver: Resolvers::TicketsConnection
    field :get_full_ticket, resolver: Resolvers::GetFullTicket
    field :get_full_credits, resolver: Resolvers::GetFullCredits
  end
end