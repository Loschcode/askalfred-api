module Types
  class MutationType < Types::BaseObject
    field :createAnonymousIdentity, mutation: Mutations::CreateAnonymousIdentity
  end
end
