class TrackingService::Slack
  include TrackingService::Utils::RequiredImplementation

  attr_reader :identity

  def initialize(identity)
    @identity = identity
  end

  def track(event, attributes)
    dispatch(event, attributes)
  end

  def alias(string)
    dispatch('alias', string: string)
  end

  def identify(attributes)
    dispatch('identify', attributes)
  end

  private

  def dispatch(event, attributes = [])
    return false if Rails.env.development?

    attributes.merge!(
      identity_id: identity.id || 'N/A',
      identity_email: identity.email || 'N/A'
    )

    client.post(
      channel: '#general',
      icon_emoji: ':alfred:',
      username: 'AskAlfred',
      attachments: [
        {
          title: event,
          color: 'good',
          fields: fields_from(attributes)
        },
      ],
    )
  end

  def fields_from(attributes)
    attributes.to_h.to_a.map do |key, value|
      {
        title: key,
        value: value,
        short: false
      }
    end
  end

  def client
    @client ||= Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
  end
end
