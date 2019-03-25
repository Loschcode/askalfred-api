module Mutations
  class SendSurpriseEmail < Mutations::BaseMutation
    description 'dispatch a confirmation of email with a surprise inside'

    field :current_identity, ::Types::Identity, null: false

    def resolve
      # TODO : dispatch things here
      {
        current_identity: current_identity
      }
    end
  end
end
