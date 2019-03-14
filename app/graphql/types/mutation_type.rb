module Types
  class MutationType < Types::BaseObject
    field :createGuest, mutation: Mutations::CreateGuest
  end
end
