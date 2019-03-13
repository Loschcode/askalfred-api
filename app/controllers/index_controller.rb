class GraphqlController < ApplicationController
  def execute
    render json: {}, status: :not_found
  end
end