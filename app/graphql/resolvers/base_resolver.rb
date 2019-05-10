module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    include ApiBase
  end
end
