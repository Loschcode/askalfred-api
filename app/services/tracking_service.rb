class TrackingService
  attr_reader :identity
  def initialize(identity)
    @identity = identity
  end

  def signed_up
    slack_service.dispatch "[WARNING] New sign-up: #{identity.email}"
  end

  def new_ticket(ticket)
    slack_service.dispatch "[WARNING] New ticket available #{ticket.id} from #{identity.email}, check it out"
  end

  def identity_removed
    slack_service.dispatch "[WARNING] Identity of role `#{identity.role }` and email #{identity.email}, was removed from the database."
  end

  def payment_failed(error)
    slack_service.dispatch "[WARNING] Identity with email #{identity.email} got an error from the webhook when trying to credit him (`#{error}`)."
  end

  private

  def slack_service
    @slack_service ||= SlackService.new
  end
end
