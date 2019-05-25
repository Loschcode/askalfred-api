module Subscriptions
  class RefreshCredits < Subscriptions::BaseSubscription
    field :success, String, null: false
  end
end
