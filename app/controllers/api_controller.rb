class ApiController < ActionController::Base
  def command
    command = params.fetch(:command) # e.g. "account_open"
    data = params.fetch(:data).to_json

    event_class = command.camelize.constantize

    result = event_class.
      create!(data: data).
      process!

    render json: result
  end
end
