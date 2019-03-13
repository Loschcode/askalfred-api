module Types
  class MutationType < Types::BaseObject
    field :createAnonymousUser, mutation: Mutations::CreateAnonymousUser
  end
end
