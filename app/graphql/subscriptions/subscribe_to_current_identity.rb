module Subscriptions
  class SubscribeToCurrentIdentity < Subscriptions::BaseSubscription
    field :current_identity, Types::Identity, null: true

    def resolve
      {
        current_identity: current_identity
      }
    end
  end
end
