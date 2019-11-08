module TrackingService::Utils::RequiredImplementation
  def track(event, attributes)
    raise Error, "track(event, attributes) not implemented in #{this.class.name}"
  end

  def alias(string)
    raise Error, "alias(string) not implemented in #{this.class.name}"
  end

  def identify(attributes)
    raise Error, "identify(attributes) not implemented in #{this.class.name}"
  end
end