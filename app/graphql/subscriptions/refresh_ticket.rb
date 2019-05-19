module Subscriptions
  class RefreshTicket < Subscriptions::BaseSubscription
    argument :id, ID, required: true

    field :ticket, Types::Ticket, null: false
  end
end
