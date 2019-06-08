# general mailer with default template
class IdentityMailer < ApplicationMailer
  def request_completed(ticket)
    set_params
    forced_title = ticket.title || 'Your request'

    set_subject('Your request was completed! 🎉')

    set_call_to_action(
      url: app_url("tickets/chat/#{ticket.id}"),
      label: 'See your request',
    )

    set_headline(
      'About',
      forced_title
    )

    set_illustration(
      image_url('symbols/illustrations/success.png'),
    )

    set_random_tips
    send_email
  end

  def request_canceled(ticket)
    set_params
    forced_title = ticket.title || 'Your request'

    set_subject('Your request was canceled! 🙁')

    set_call_to_action(
      url: app_url("tickets/chat/#{ticket.id}"),
      label: 'See your request',
    )

    set_headline(
      'About',
      forced_title
    )

    set_illustration(
      image_url('symbols/illustrations/canceled.png'),
    )

    set_random_tips
    send_email
  end

  def alfred_needs_answers(ticket)
    set_params
    forced_title = ticket.title || 'Your request'

    set_subject('I need your input! 👍')

    set_call_to_action(
      url: app_url("tickets/chat/#{ticket.id}"),
      label: 'See my answer',
    )

    set_headline(
      'About',
      forced_title
    )

    set_illustration(
      image_url('symbols/illustrations/written.png'),
    )

    set_random_tips
    send_email
  end

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
      image_url('symbols/illustrations/gift.png'),
    )

    set_random_tips
    send_email
  end

  def recovery_email
    set_params

    set_subject('Recover your account! 🔑')

    set_call_to_action(
      url: app_url("connect/recovery-email?recovery_token=#{@identity.recovery_token}"),
      label: 'Recover now',
    )

    set_headline(
      "Have you lost",
      "Your access?"
    )

    set_illustration(
      image_url('symbols/illustrations/keys.png'),
    )

    set_random_tips
    send_email
  end

  private

  def set_random_tips
    add_tip(
      image: image_url('symbols/tips/idea.png'),
      title: 'Need more time with Alfred?',
      content: 'He\'s very flexible. If you don\'t have enough credit, he will continue your task anyway. You\'ll have to charge up your account but only for the next one!',
      padding: '20px'
    )

    add_tip(
      image: image_url('symbols/tips/keys.png'),
      title: 'Security tips',
      content: 'What happens with Alfred, stay with Alfred. He won\'t communicate any of your information to any third party, and anything you write will be encrypted and kept secret by the service.',
      padding: '10px'
    )
  end

  def send_email
    return if @identity.email_opt_out_at
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
