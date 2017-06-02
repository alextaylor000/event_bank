Rails.application.routes.draw do
  post :api, to: "api#command"
end
