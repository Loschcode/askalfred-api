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
      "#{identity.first_name} #{identity.last_name} <#{identity.mailbox}>"
    end
  end
end
