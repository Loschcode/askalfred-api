module Types
  class QueryType < Types::BaseObject
    extend ActiveSupport::Concern

    field :currentIdentity, resolver: Resolvers::CurrentIdentity
    field :tickets_connection, resolver: Resolvers::TicketsConnection
    field :get_ticket, resolver: Resolvers::GetTicket
  end
end