module Types
  class SetPaymentIntentInput < Types::BaseInputObject
    argument :amount, Integer, required: true
    argument :stripe_payment_intent_id, String, required: false
  end
end

module Mutations
  class SetPaymentIntent < Mutations::BaseMutation
    argument :input, Types::SetPaymentIntentInput, required: true
    field :id, String, null: false
    field :client_secret, String, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      # NOTE : we don't need more information than that for the payment intent
      ActiveRecord::Base.transaction do
        amount = input[:amount] * 100 # in cents
        stripe_payment_intent_id = input[:stripe_payment_intent_id]

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

        # STEP 2 : create the payment intent
        stripe_payment_intent = begin
          if stripe_payment_intent_id.present?
            Stripe::PaymentIntent.update(
              stripe_payment_intent_id,
              amount: amount
            )
          else
            Stripe::PaymentIntent.create(
              amount: amount,
              currency: 'eur',
              # switch to `off_session`
              # for asynchronous charges
              setup_future_usage: 'on_session',
              customer: current_identity.stripe_customer_id,
              payment_method: current_identity.stripe_payment_method_id
            )
          end
        rescue Stripe::InvalidRequestError => exception
          raise GraphQL::ExecutionError.new('We could not set this amount. Please try again.')
        end

        {
          id: stripe_payment_intent.id,
          client_secret: stripe_payment_intent.client_secret
        }
      end
    end
  end
end
