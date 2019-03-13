module Queries
  class BaseQuery < GraphQL::Schema::Resolver
    include ApiBase
  end
end
