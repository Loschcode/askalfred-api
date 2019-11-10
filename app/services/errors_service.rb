class ErrorsService
  attr_reader :exception

  def initialize(exception)
    @exception = exception
  end

  def perform
    return if silent_mode?
    return if ignored_exceptions?

    Raven.capture_exception(exception, message: exception.message)
  end

  def silent_mode?
    Rails.env.development?
  end

  def ignored_exceptions?
    return true if exception.class == ActionController::RoutingError
    return true if exception.class == ActiveRecord::RecordNotFound
    false
  end
end