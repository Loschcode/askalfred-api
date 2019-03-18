class AskalfredApiSchema < GraphQL::Schema
  mutation Types::MutationType
  query Types::QueryType
  subscription Types::SubscriptionType
end
