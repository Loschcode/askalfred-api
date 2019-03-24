module Types
  class MutationType < Types::BaseObject
    field :createGuest, mutation: Mutations::CreateGuest
    field :storeIdentityName, mutation: Mutations::StoreIdentityName
    field :storeIdentityEmail, mutation: Mutations::StoreIdentityEmail
  end
end
