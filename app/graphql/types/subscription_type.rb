module Types
  class SubscriptionType < GraphQL::Schema::Object
    field :refreshCurrentIdentity, resolver: Subscriptions::RefreshCurrentIdentity, subscription_scope: :current_identity_id
    field :refreshTicketsList, resolver: Subscriptions::RefreshTicketsList, subscription_scope: :current_identity_id
    field :refreshTicket, resolver: Subscriptions::RefreshTicket, subscription_scope: :current_identity_id
    field :refreshCredits, resolver: Subscriptions::RefreshCredits, subscription_scope: :current_identity_id
  end
end
