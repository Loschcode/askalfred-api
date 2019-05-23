module Types
  class SubscriptionType < GraphQL::Schema::Object
    field :subscribeToCurrentIdentity, resolver: Subscriptions::SubscribeToCurrentIdentity, subscription_scope: :current_identity_id
    field :refreshTicketsConnection, resolver: Subscriptions::RefreshTicketsConnection, subscription_scope: :current_identity_id
    field :refreshTicket, resolver: Subscriptions::RefreshTicket, subscription_scope: :current_identity_id
    field :refreshCredits, resolver: Subscriptions::RefreshCredits, subscription_scope: :current_identity_id
  end
end
