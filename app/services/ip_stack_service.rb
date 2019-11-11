require 'open-uri'

class IpStackService
  attr_reader :ip
  def initialize(ip)
    @ip = ip
  end

  def perform
    return {} if response[:success] == false
    response
  end

  def response
    JSON.load(
      open(url)
    ).deep_symbolize_keys
  end

  def url
    "http://api.ipstack.com/#{ip}?access_key=#{ENV['IPSTACK_API_KEY']}"
  end
end