require 'mixpanel-ruby'

class MixpanelService
  attr_reader :identity

  def initialize(identity)
    @identity = identity
  end

  def track(attributes)
    tracker.track(identity.id, attributes)
  end

  def alias(string)
    tracker.alias(string, identity.id)
  end

  def identify(attributes)
    tracker.people.set(identity.id, attributes)
  end

  def tracker
    @tracker ||= ::Mixpanel::Tracker.new(ENV['MIXPANEL_TOKEN'])
  end
end