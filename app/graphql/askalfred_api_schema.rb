class AskalfredApiSchema < GraphQL::Schema
  use GraphQL::Subscriptions::ActionCableSubscriptions
  use GraphQL::Cache

  mutation Types::MutationType
  query Types::QueryType
  subscription Types::SubscriptionType
end

# problem with puma and reload, i don't know why exactly
# https://github.com/rmosolgo/graphql-ruby/issues/1505#issuecomment-428693570
AskalfredApiSchema.graphql_definition
