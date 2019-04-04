module Mutations
  class GetForFree < Mutations::BaseMutation
    class Error < StandardError; end
    TWENTY_MINUTES = 20 * 60

    description 'creates a guest identity'

    field :credit, ::Types::Credit, null: false

    def resolve
      return unless current_identity

      throw Error, 'You already got this surprise.' if current_identity.credits.count > 0

      credit = Credit.create!(
        identity: current_identity,
        time: TWENTY_MINUTES
      )

      {
        credit: credit
      }
    end
  end
end
