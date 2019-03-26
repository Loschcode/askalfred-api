class IdentityMailer < ApplicationMailer
  default from: 'support@askalfred.app'

  def surprise_email
    @identity = params[:identity]
    @call_to_action = "#{root_url}getting-started/surprise?confirmation_token=#{@identity.confirmation_token}"

    mail(to: @identity.email, subject: 'Surprise Surprise!')
  end
end
