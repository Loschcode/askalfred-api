module Types
  class QueryType < Types::BaseObject
    extend ActiveSupport::Concern

    field :currentUser, resolver: Queries::ShowCurrentUser
  end
end