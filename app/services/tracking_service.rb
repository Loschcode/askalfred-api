class TrackingService
  attr_reader :identity

  def initialize(identity)
    @identity = identity
  end

  def method_missing(method, *args, &block)
    mixpanel.send(method, *args)
    slack.send(method, *args)
  end

private

  def mixpanel
    @mixpanel ||= TrackingService::Mixpanel.new(identity)
  end

  def slack
    @slack ||= TrackingService::Slack.new(identity)
  end
end
