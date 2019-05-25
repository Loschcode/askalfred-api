module Subscriptions
  class RefreshCurrentIdentity < Subscriptions::BaseSubscription
    field :current_identity, Types::Identity, null: true

    def resolve
      {
        current_identity: current_identity
      }
    end
  end
end
 