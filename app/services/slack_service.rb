class SlackService
  attr_reader :identity
  def initialize(identity)
    @identity = identity
  end

  def signed_up
    dispatch "[WARNING] New sign-up: #{identity.email}"
  end

  def new_ticket(ticket)
    dispatch "[WARNING] New ticket available #{ticket.id} from #{identity.email}, check it out"
  end

  private

  def client
    @client ||= Slack::Web::Client.new
  end

  def dispatch(text)
    return false if Rails.env.development?
    client.chat_postMessage(channel: '#general', text: text, as_user: true)
  rescue Slack::Web::Api::Errors::SlackError
    false
  end
end
