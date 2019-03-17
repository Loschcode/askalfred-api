module Queries
  class CurrentIdentity < Queries::BaseQuery
    type Types::Identity, null: true
    description 'Get the current user'

    def resolve
      current_identity
    end
  end
end
