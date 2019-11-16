class IndexController < ApiController
  def show
    render json: { application: 'askalfred' }, status: :not_found
  end
end
