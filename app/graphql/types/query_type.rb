module Types
  class QueryType < Types::BaseObject
    extend ActiveSupport::Concern

    field :currentIdentity, resolver: Resolvers::CurrentIdentity
    # field :ticketsList, resolver: Resolvers::ticketsList

    field :tickets_connection, resolver: Resolvers::TicketsConnection
  end
end