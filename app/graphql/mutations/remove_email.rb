module Types
  class RemoveEmailInput < Types::BaseInputObject
    description 'remove email from list'
    argument :email, String, 'email', required: true
    argument :reason, String, 'reason', required: false
  end
end

module Mutations
  class RemoveEmail < Mutations::BaseMutation
    argument :input, Types::RemoveEmailInput, required: true
    field :success, Boolean, null: false

    def resolve(input:)
      identity = Identity.where(email: input[:email], email_opt_out_at: nil).take
      return GraphQL::ExecutionError.new('This email does not match anyone or has already been removed. Please try again.') unless identity.present?

      identity.update(
        email_opt_out_at: Time.now
      )

      if identity.errors.any?
        return GraphQL::ExecutionError.new identity.errors.full_messages.join(', ')
      end

      ActionMailer::Base.mail(
        from: "support@askalfred.app",
        to: "support@askalfred.app",
        subject: "Unsubscribe email",
        body: "Email `#{input[:email]}` unsubscribed with the reason `#{input[:reason]}`"
      ).deliver

      RefreshService.new(identity).myself

      {
        success: true
      }
    end
  end
end