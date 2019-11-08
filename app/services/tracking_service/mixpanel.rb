require 'mixpanel-ruby'

class TrackingService::Mixpanel
  include TrackingService::Utils::RequiredImplementation

  attr_reader :identity

  def initialize(identity)
    @identity = identity
  end

  def track(event, attributes)
    tracker.track(identity.id, event, attributes)
  end

  def alias(string)
    tracker.alias(string, identity.id)
  end

  def identify(attributes)
    tracker.people.set(identity.id, attributes)
  end

  private

  def tracker
    @tracker ||= ::Mixpanel::Tracker.new(ENV['MIXPANEL_TOKEN'])
  end
end
