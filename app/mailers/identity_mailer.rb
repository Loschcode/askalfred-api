# general mailer with default template
class IdentityMailer < ApplicationMailer
  default from: 'support@askalfred.app'

  def confirm_email
    set_params

    set_subject('Surprise from Alfred! 🎉')

    set_call_to_action(
      url: "#{root_url}getting-started/confirm-email?confirmation_token=#{@identity.confirmation_token}",
      label: 'Confirm my email',
    )

    set_explanations(
      image: image_url('symbols/gift.svg'),
      text: 'To receive your gift, I need to know you received my email. Please click on the button to confirm that.'
    )

    set_headline(
      'Something to say',
      'on max two lines'
    )

    add_tip(
      image: image_url('symbols/idea.svg'),
      title: 'Title',
      content: 'Morbi sit amet sapien placerat lorem ultrices euismod sed at neque. Mauris tristique, lacus id maximus convallis, neque tellus ornare risus',
      padding: '20px'
    )

    add_tip(
      image: image_url('symbols/keys.svg'),
      title: 'Title',
      content: 'Morbi sit amet sapien placerat lorem ultrices euismod sed at neque. Mauris tristique, lacus id maximus convallis, neque tellus ornare risus',
      padding: '10px'
    )

    send_email
  end

  def recovery_email
    confirm_email
  end

  private

  def send_email
    mail(to: @identity.email, subject: @subject, template_name: 'heavy')
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

  def set_explanations(text:, image:)
    @explanations = { text: text, image: image }
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
end
