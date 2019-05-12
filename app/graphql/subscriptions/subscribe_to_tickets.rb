module Subscriptions
  class SubscribeToTickets < Subscriptions::BaseSubscription
    field :tickets_connection, Types::TicketsConnection, null: true

    def resolve
      {
        tickets_connection: current_identity.tickets
      }
    end
  end
end
