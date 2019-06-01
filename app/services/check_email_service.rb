require 'rest-client'

class CheckEmailService
  attr_reader :email

  def initialize(email)
    @email = email
  end

  def perform
    response[:disposable] != true
  end

  private

  def response
    JSON.parse(api_result.body).deep_symbolize_keys
  rescue JSON::ParserError
    {}
  end

  def api_result
    @api_result ||= RestClient.get(api_endpoint)
  end

  def api_endpoint
    "https://open.kickbox.com/v1/disposable/#{email}"
  end
end