Rails.application.routes.draw do
  root 'hello#index'
  get '/metrics', to: 'metrics#index'
end 