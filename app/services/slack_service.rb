class SlackService
  def dispatch(text)
    # return false if Rails.env.development?
    client.chat_postMessage(channel: '#general', text: text, as_user: true)
  rescue Slack::Web::Api::Errors::SlackError
    false
  end

  private

  def client
    @client ||= Slack::Web::Client.new
  end
end
