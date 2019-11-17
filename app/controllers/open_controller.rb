class OpenController < ApiController
  def create_guest
    identity = CreateGuestService.new(request, params).perform

    render json: {
      token: identity.token
    }
  end
end
