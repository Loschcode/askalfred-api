class IdentityMailer < ApplicationMailer
  default from: 'support@askalfred.app'

  def confirm_email
    @identity = params[:identity]
    @call_to_action = "#{root_url}getting-started/confirm-email?confirmation_token=#{@identity.confirmation_token}"

    mail(to: @identity.email, subject: 'Surprise Surprise!')
  end

  def recovery_email
    @identity = params[:identity]
    @call_to_action = "#{root_url}connect/recovery-email?recovery_token=#{@identity.recovery_token}"

    mail(to: @identity.email, subject: 'Recovery email')
  end
end
