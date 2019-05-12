module Resolvers
  class TicketsConnection < Resolvers::BaseResolver
    type Types::TicketsConnection, null: false

    def resolve
      current_identity.tickets
    end
  end
end
