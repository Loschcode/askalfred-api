module Mutations
  class GetForFree < Mutations::BaseMutation
    class Error < StandardError; end

    TWENTY_MINUTES = 20 * 60

    description 'creates a guest identity'

    field :success, Boolean, null: false

    def resolve
      return unless current_identity

      throw Error, 'You already got this surprise.' if current_identity.credits.count > 0

      Credit.create!(
        identity: current_identity,
        time: TWENTY_MINUTES
      )

      {
        success: true
      }
    end
  end
end
