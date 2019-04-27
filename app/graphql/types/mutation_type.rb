module Types
  class MutationType < Types::BaseObject
    field :confirmEmail, mutation: Mutations::ConfirmEmail
    field :convertGuestToCustomer, mutation: Mutations::ConvertGuestToCustomer
    field :createGuest, mutation: Mutations::CreateGuest
    field :storeIdentityName, mutation: Mutations::StoreIdentityName
    field :storeIdentityEmail, mutation: Mutations::StoreIdentityEmail
    field :sendSurpriseEmail, mutation: Mutations::SendSurpriseEmail
    field :sendRecoveryEmail, mutation: Mutations::SendRecoveryEmail
    field :getForFree, mutation: Mutations::GetForFree
    field :storeIdentityPassword, mutation: Mutations::StoreIdentityPassword
    field :unsetPassword, mutation: Mutations::UnsetPassword
  end
end
