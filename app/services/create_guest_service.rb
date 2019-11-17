class CreateGuestService
  attr_reader :request, :params

  def initialize(request, params)
    @request = request
    @params = params
  end

  def perform
    Identity.create!(attributes).tap do |identity|
      StoreLocationWorker.perform_async(identity.id)
    end
  end

  def attributes
    {
      role: 'guest',
      origin: origin,
      ip: request.remote_ip,
      user_agent: request.user_agent
    }
  end

  def origin
    if params[:origin].present?
      if params[:origin].instance_of? String
        origin_from(params[:origin])
      else
        params[:origin].permit!.to_h
      end
    else
      {}
    end
  end

  def origin_from(string)
    JSON.parse(string)
  rescue JSON::ParserError
    {}
  end
end
