module Types
  class ChargeCustomerInput < Types::BaseInputObject
    description 'charge a customer and give him credit for it'
    argument :amount, Integer, required: true
  end
end

module Mutations
  class ChargeCustomer < Mutations::BaseMutation
    description 'send a message to a specific ticket'

    argument :input, Types::ChargeCustomerInput, required: true
    field :stripe_charge_id, String, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      unless current_identity.stripe_customer_id
        raise GraphQL::ExecutionError.new('Our payment service did not recognize you.')
      end

      unless current_identity.stripe_card_id
        raise GraphQL::ExecutionError.new('We cannot charge you without credit card information.')
      end

      ActiveRecord::Base.transaction do
        amount = input[:amount] * 100 # in cents
        time = 4 * amount # in seconds

        stripe_charge = begin
          Stripe::Charge.create(
            customer: current_identity.stripe_customer_id,
            source: current_identity.stripe_card_id,
            amount: amount,
            currency: 'eur',
          )
        rescue Stripe::CardError => exception
          raise GraphQL::ExecutionError.new('We could not top up your account. Is your card still valid? Please try again.')
        end

        credit = Credit.create(
          identity: current_identity,
          stripe_charge_id: stripe_charge.id,
          time: time,
          origin: 'charge_customer'
        )

        if credit.errors.any?
          raise GraphQL::ExecutionError.new credit.errors.full_messages.join(', ')
        end

        AskalfredApiSchema.subscriptions.trigger('refreshCredits', {}, { success: true }, scope: current_identity.id)

        {
          stripe_charge_id: credit.stripe_charge_id
        }
      end
    end

    private

    def to_stripe(input_origin)
      number = input_origin[:card_number].gsub(' ', '')
      exp_month = input_origin[:expiration_date].split('/').first
      exp_year = input_origin[:expiration_date].split('/').last
      cvc = input_origin[:security_code]

      {
        number: number,
        exp_month: exp_month,
        exp_year: exp_year,
        cvc: cvc
      }
    end
  end
end