module Types
  class SubscriptionType < GraphQL::Schema::Object
    field :subscribeToBullshit, resolver: Subscriptions::SubscribeToBullshit
  end
end