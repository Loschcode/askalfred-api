module Resolvers
  class TicketsConnection < Resolvers::BaseResolver
    type Types::TicketsConnection, null: true

    def resolve
      current_identity.tickets
    end
  end
end
