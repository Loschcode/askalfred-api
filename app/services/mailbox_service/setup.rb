module MailboxService
  class Setup
  attr_reader :identity

  def initialize(identity)
    @identity = identity
  end

  def perform
    validate
    free_mailbox
  end

  private

  def validate
    raise Error, 'Cannot create mailbox without full name' if identity.first_name.blank? || identity.last_name.blank?
  end

  def free_mailbox
    return mailbox_selector unless Identity.where(mailbox: mailbox_selector).exists?

    iteration = 1
    while Identity.where(mailbox: mailbox_selector(iteration)).exists?
      iteration += 1
    end

    mailbox_selector(iteration)
  end

  def mailbox_selector(iteration = '')
    "#{identity.first_name}.#{identity.last_name}#{iteration}@askalfred.to".downcase
  end
  end
end