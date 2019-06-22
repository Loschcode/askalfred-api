module MailboxService
  class Sender
    attr_reader :identity, :ticket, :to, :subject, :body

    def initialize(identity:, to:, subject:, body:, ticket: nil)
      @identity = identity
      @ticket = ticket

      @to = to
      @subject = subject
      @body = body
    end

    def perform
      MailboxMail.transaction do
        MailboxMail.create!(
          ticket: ticket,
          identity: identity,
          direction: 'sent',
          from: from,
          to: to,
          subject: subject,
          body: body
        )

        ActionMailer::Base.mail(
          from: from,
          to: to,
          subject: subject,
          body: body
        ).deliver
      end
    end

    def from
      "Alfred Windsor <#{email}>"
    end

    def email
      if ticket
        identity.mailbox.gsub('@', "+#{ticket.id}@")
      else
        identity.mailbox
      end
    end
  end
end
