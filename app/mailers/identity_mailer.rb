class IdentityMailer < ApplicationMailer
  default from: 'support@askalfred.app'

  def surprise_email
    @identity = params[:identity]
    @call_to_action = "#{root_url}getting-started/surprise?confirmation_token=#{@identity.confirmation_token}"

    mail(to: @identity.email, subject: 'Surprise Surprise!')
  end

  def recovery_email
    @identity = params[:identity]
    @call_to_action = "#{root_url}connect/reset-your-password?recovery_token=#{@identity.recovery_token}"

    mail(to: @identity.email, subject: 'Recovery email')
  end
end
