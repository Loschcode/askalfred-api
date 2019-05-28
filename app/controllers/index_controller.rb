class IndexController < ApiController
  def show
    render json: {}, status: :not_found
  end
end
