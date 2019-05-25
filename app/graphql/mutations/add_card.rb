module Types
  class AddCardInput < Types::BaseInputObject
    description 'add a card'
    argument :card_number, String, required: true
    argument :expiration_date, String, required: true
    argument :security_code, String, required: true
  end
end

module Mutations
  class AddCard < Mutations::BaseMutation
    description 'send a message to a specific ticket'

    argument :input, Types::AddCardInput, required: true
    field :stripe_customer_id, String, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      ActiveRecord::Base.transaction do
        # TODO : make the customer,
        # add the card in it and save the stripe customer id

        binding.pry

        current_identity.update stripe_customer_id: stripe_customer_id 
        
        AskalfredApiSchema.subscriptions.trigger('subscribeToCurrentIdentity', {}, {
          current_identity: current_identity
        }, scope: current_identity.id)


        {
          stripe_customer_id: current_identity.stripe_customer_id
        }
      end
    end
  end
end