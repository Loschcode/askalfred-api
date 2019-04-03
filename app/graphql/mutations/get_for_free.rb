module Mutations
  class GetForFree < Mutations::BaseMutation
    description 'creates a guest identity'

    field :success, Boolean, null: false

    def resolve
      return unless current_identity

      # TODO : logic for the surprise
      {
        success: true
      }
    end
  end
end
