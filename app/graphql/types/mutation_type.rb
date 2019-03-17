module Types
  class MutationType < Types::BaseObject
    field :createGuest, mutation: Mutations::CreateGuest
    field :storeIdentityName, mutation: Mutations::StoreIdentityName
  end
end
