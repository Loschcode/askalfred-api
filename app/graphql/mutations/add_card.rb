module Types
  class AddCardInput < Types::BaseInputObject
    description 'add a card'
    argument :card_token, String, required: true
  end
end

module Mutations
  class AddCard < Mutations::BaseMutation
    description 'send a message to a specific ticket'

    argument :input, Types::AddCardInput, required: true
    field :stripe_customer_id, String, null: false
    field :stripe_card_id, String, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      # STEP 1 : register customer
      unless current_identity.stripe_customer_id
        stripe_customer = Stripe::Customer.create(
          email:  current_identity.email,
          metadata: {
            identity_id: current_identity.id
          }
        )

        unless stripe_customer.id
          raise GraphQL::ExecutionError.new('It was not possible to register your account to our payment service.')
        end

        current_identity.update stripe_customer_id: stripe_customer.id
      end

      # STEP 2 : save card
      # if the customer already has a card we will replace it by this one
      stripe_card = begin
        Stripe::Customer.create_source(current_identity.stripe_customer_id,
          source: input[:card_token],
        )
      rescue Stripe::CardError => exception
        raise GraphQL::ExecutionError.new('Your card does not seem to be valid. Please try again.')
      end

      current_identity.update stripe_card_id: stripe_card.id

      # STEP 3 : dispatch everything
      refresh_service.myself

      {
        stripe_customer_id: current_identity.stripe_customer_id,
        stripe_card_id: current_identity.stripe_card_id
      }
    end

    private

    # def to_stripe(input_origin)
    #   number = input_origin[:card_number].gsub(' ', '')
    #   exp_month = input_origin[:expiration_date].split('/').first
    #   exp_year = input_origin[:expiration_date].split('/').last
    #   cvc = input_origin[:security_code]

    #   {
    #     number: number,
    #     exp_month: exp_month,
    #     exp_year: exp_year,
    #     cvc: cvc
    #   }
    # end 
  end
end