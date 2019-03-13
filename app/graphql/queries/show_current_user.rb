module Queries
  class ShowCurrentUser < Queries::BaseQuery
    type Types::User, null: true
    description "Get the current user"

    def resolve
      current_user
    end
  end
end
