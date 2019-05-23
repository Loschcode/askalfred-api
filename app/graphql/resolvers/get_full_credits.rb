module Resolvers
  class GetFullCredits < Resolvers::BaseResolver
    type [Types::Credit], null: true

    def resolve
      current_identity.credits
    end
  end
end
