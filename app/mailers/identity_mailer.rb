# general mailer with default template
class IdentityMailer < ApplicationMailer
  def confirm_email
    set_params

    set_subject('Surprise from Alfred! 🎉')

    set_call_to_action(
      url: app_url("getting-started/confirm-email?confirmation_token=#{@identity.confirmation_token}"),
      label: 'Get my gift now',
    )

    set_headline(
      "Hey #{@identity.first_name}!",
      "I've got a surprise for you"
    )

    set_illustration(
      image_url('symbols/gift.svg'),
    )

    set_random_tips
    send_email
  end

  def recovery_email
    set_params

    set_subject('Recover your account! 🔑')

    set_call_to_action(
      url: app_url("getting-started/confirm-email?confirmation_token=#{@identity.confirmation_token}"),
      label: 'Get my gift now',
    )

    set_headline(
      "Hey #{@identity.first_name}!",
      "I've got a surprise for you"
    )

    set_illustration(
      image_url('symbols/gift.svg'),
    )

    set_random_tips
    send_email
  end

  private

  def set_random_tips
    add_tip(
      image: image_url('symbols/idea.svg'),
      title: 'Need more time with Alfred?',
      content: 'He\'s very flexible. If you don\'t have enough credit, he will continue your task anyway. You\'ll have to charge up your account but only for the next one!',
      padding: '20px'
    )

    add_tip(
      image: image_url('symbols/keys.svg'),
      title: 'Security tips',
      content: 'What happens with Alfred, stay with Alfred. He won\'t communicate any of your information to any third party, and anything you write will be encrypted and kept secret by the service.',
      padding: '30px'
    )
  end

  def send_email
    mail(to: @identity.email, subject: @subject)
  end

  def set_params
    @identity = params[:identity]
  end

  def set_subject(subject)
    @subject = subject
  end

  def set_headline(*headline)
    @headline = headline
  end

  def set_illustration(image)
    @illustration = image
  end

  def set_call_to_action(label:, url:)
    @call_to_action = { label: label, url: url }
  end

  def add_tip(image:, title:, content:, padding:)
    @tips ||= []
    @tips << { image: image, title: title, content: content, padding: padding }
  end

  def image_url(image)
    "#{root_url}images/emails/#{image}"
  end

  def app_url(url)
    "#{root_url}#{url}"
  end
end
