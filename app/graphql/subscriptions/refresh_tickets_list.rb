module Subscriptions
  class RefreshTicketsList < Subscriptions::BaseSubscription
    field :success, String, null: false
  end
end
