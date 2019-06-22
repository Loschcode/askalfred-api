class Webhooks::Mailgun::IncomingsController < ApiController
  def create
    MailboxMail.create!(
      ticket: ticket,
      identity: identity,
      direction: 'received',
      from: from,
      to: to,
      subject: subject,
      body: body,
      raw: params
    )

    render json: {}, status: :ok
  end

private

  def ticket
    Ticket.find_by(id: ticket_id) if ticket_id
  end

  def ticket_id
    /\+(.*)@/ =~ to
    Regexp.last_match(1)
  end

  def identity
    if ticket
      ticket.identity
    else
      Identity.find_by!(mailbox: to)
    end
  end

  def from
    params[:sender]
  end

  def to
    params[:recipient]
  end

  def subject
    params[:subject]
  end

  # there are other versions with html included, etc.
  def body
    params['body-plain']
  end
end
