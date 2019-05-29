module Mutations
  class GetCreditForFree < Mutations::BaseMutation
    TWENTY_MINUTES = 20 * 60

    description 'creates a guest identity'

    field :credit, ::Types::Credit, null: false

    def resolve
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity
      return GraphQL::ExecutionError.new('You already got this surprise.') if current_identity.credits.count > 0

      credit = Credit.create(
        identity: current_identity,
        time: TWENTY_MINUTES,
        origin: 'registration_bonus'
      )

      if credit.errors.any?
        return GraphQL::ExecutionError.new credit.errors.full_messages.join(', ')
      end

      refresh_service.myself

      {
        credit: credit
      }
    end
  end
end
