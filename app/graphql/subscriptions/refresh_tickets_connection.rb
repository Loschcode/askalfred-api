module Subscriptions
  class RefreshTicketsConnection < Subscriptions::BaseSubscription
    field :success, String, null: false
  end
end
