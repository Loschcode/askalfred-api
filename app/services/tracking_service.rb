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

  private

  def slack_service
    @slack_service ||= SlackService.new
  end
end
