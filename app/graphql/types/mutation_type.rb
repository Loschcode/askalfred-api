module Types
  class MutationType < Types::BaseObject
    field :confirmEmail, mutation: Mutations::ConfirmEmail
    field :createGuest, mutation: Mutations::CreateGuest
    field :storeIdentityName, mutation: Mutations::StoreIdentityName
    field :storeIdentityEmail, mutation: Mutations::StoreIdentityEmail
    field :sendSurpriseEmail, mutation: Mutations::SendSurpriseEmail
    field :sendRecoveryEmail, mutation: Mutations::SendRecoveryEmail
    field :getForFree, mutation: Mutations::GetForFree
    field :storeIdentityPassword, mutation: Mutations::StoreIdentityPassword
  end
end
