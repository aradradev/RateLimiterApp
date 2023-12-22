Rails.application.routes.draw do
  get '/limited', to: 'api#limited'
  get '/unlimited', to: 'api#unlimited'
end
