module Subscriptions
  class RefreshCredits < Subscriptions::BaseSubscription
    field :credits, [Types::Credit], null: true
  end
end
