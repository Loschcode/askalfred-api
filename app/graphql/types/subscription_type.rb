module Types
  class SubscriptionType < GraphQL::Schema::Object
    field :subscribeToBullshit, resolver: Subscriptions::SubscribeToBullshit, subscription_scope: :current_identity_id
  end
end