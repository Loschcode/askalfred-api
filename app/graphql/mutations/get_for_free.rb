module Mutations
  class GetForFree < Mutations::BaseMutation
    TWENTY_MINUTES = 20 * 60

    description 'creates a guest identity'

    field :credit, ::Types::Credit, null: false

    def resolve
      return unless current_identity
      return GraphQL::ExecutionError.new('You already got this surprise.') if current_identity.credits.count > 0

      credit = Credit.create(
        identity: current_identity,
        time: TWENTY_MINUTES
      )

      if credit.errors.any?
        return GraphQL::ExecutionError.new credit.errors.full_messages.join(', ')
      end

      {
        credit: credit
      }
    end
  end
end
