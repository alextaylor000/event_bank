class ApiController < ActionController::Base
  def command
    command = params.fetch(:command)
    data = params.fetch(:data).as_json

    render json: data
  end
end
