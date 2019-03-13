module Types
  class QueryType < Types::BaseObject
    extend ActiveSupport::Concern

    field :currentIdentity, resolver: Queries::ShowCurrentIdentity
  end
end