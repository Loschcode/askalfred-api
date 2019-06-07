class ErrorsService
  attr_reader :exception

  def initialize(exception)
    @exception = exception
  end

  def perform
    return if silent?

    Raven.capture_exception(exception, message: exception.message)
  end

  def silent?
    Rails.env.development?
  end
end