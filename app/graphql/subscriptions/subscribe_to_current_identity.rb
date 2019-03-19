module Subscriptions
  class SubscribeToCurrentIdentity < Subscriptions::BaseSubscription
    description 'subscription to current identity'

    field :current_identity, Types::Identity, null: true

    # field :id, String, null: true
    # field :first_name, String, null: true
    # field :last_name, String, null: true

    def resolve
      {
        current_identity: current_identity
      }
      # return unless current_identity

      # {
      #   id: current_identity.id,
      #   first_name: current_identity.first_name,
      #   last_name: current_identity.last_name
      # }
    end
  end
end
