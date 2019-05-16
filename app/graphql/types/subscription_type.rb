module Types
  class SubscriptionType < GraphQL::Schema::Object
    field :subscribeToCurrentIdentity, resolver: Subscriptions::SubscribeToCurrentIdentity, subscription_scope: :current_identity_id
    field :refreshTicketsConnection, resolver: Subscriptions::RefreshTicketsConnection, subscription_scope: :current_identity_id
  end
end