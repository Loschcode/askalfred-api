module Mutations
  class SetSetupIntent < Mutations::BaseMutation
    field :id, String, null: false
    field :client_secret, String, null: false

    def resolve
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      # NOTE : we don't need more information than that for the payment intent
      ActiveRecord::Base.transaction do
        # STEP 1 : register customer
        unless current_identity.stripe_customer_id
          stripe_customer = Stripe::Customer.create(
            email: current_identity.email,
            metadata: {
              identity_id: current_identity.id
            }
          )

          unless stripe_customer.id
            raise GraphQL::ExecutionError.new('It was not possible to register your account to our payment service.')
          end

          current_identity.update! stripe_customer_id: stripe_customer.id
        end

        # STEP 2 : create the setup intent
        stripe_setup_intent = begin
          Stripe::SetupIntent.create(
            usage: 'on_session',
            metadata: {
              identity_id: current_identity.id
            }
          )
        rescue Stripe::InvalidRequestError => exception
          raise GraphQL::ExecutionError.new('We could not initialize the card module. Please try again.')
        end

        {
          id: stripe_setup_intent.id,
          client_secret: stripe_setup_intent.client_secret
        }
      end
    end
  end
end
