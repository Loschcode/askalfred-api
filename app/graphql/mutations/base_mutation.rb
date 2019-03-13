module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    include ApiBase
  end
end
