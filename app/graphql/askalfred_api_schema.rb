class AskalfredApiSchema < GraphQL::Schema
  use GraphQL::Subscriptions::ActionCableSubscriptions

  mutation Types::MutationType
  query Types::QueryType
  subscription Types::SubscriptionType
end
