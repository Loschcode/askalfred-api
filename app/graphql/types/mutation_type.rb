module Types
  class MutationType < Types::BaseObject
    field :confirmEmail, mutation: Mutations::ConfirmEmail
    field :createGuest, mutation: Mutations::CreateGuest
    field :storeIdentityName, mutation: Mutations::StoreIdentityName
    field :storeIdentityEmail, mutation: Mutations::StoreIdentityEmail
    field :sendSurpriseEmail, mutation: Mutations::SendSurpriseEmail
  end
end
