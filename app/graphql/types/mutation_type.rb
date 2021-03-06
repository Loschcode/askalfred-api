module Types
  class MutationType < Types::BaseObject
    field :allowExpense, mutation: Mutations::AllowExpense
    field :confirmEmail, mutation: Mutations::ConfirmEmail
    field :convertGuestToCustomer, mutation: Mutations::ConvertGuestToCustomer
    field :createGuest, mutation: Mutations::CreateGuest
    field :createTicket, mutation: Mutations::CreateTicket
    field :cancelTicket, mutation: Mutations::CancelTicket
    field :deleteGuest, mutation: Mutations::DeleteGuest
    field :storeIdentityName, mutation: Mutations::StoreIdentityName
    field :storeIdentityEmail, mutation: Mutations::StoreIdentityEmail
    field :sendConfirmEmail, mutation: Mutations::SendConfirmEmail
    field :sendDataCollectionForm, mutation: Mutations::SendDataCollectionForm
    field :sendMessage, mutation: Mutations::SendMessage
    field :sendFile, mutation: Mutations::SendFile
    field :sendRecoveryEmail, mutation: Mutations::SendRecoveryEmail
    field :setPaymentIntent, mutation: Mutations::SetPaymentIntent
    field :setSetupIntent, mutation: Mutations::SetSetupIntent
    field :signIn, mutation: Mutations::SignIn
    field :getCreditForFree, mutation: Mutations::GetCreditForFree
    field :removeEmail, mutation: Mutations::RemoveEmail
    field :storeIdentityPassword, mutation: Mutations::StoreIdentityPassword
    field :resetPassword, mutation: Mutations::ResetPassword
    field :unsetPassword, mutation: Mutations::UnsetPassword
    field :trackAction, mutation: Mutations::TrackAction
  end
end
