Rails.application.routes.draw do
  # get '/stories/index'
  # get '/stories/new'
  # post '/stories', to: 'stories#create'

  resources :stories
  root to: 'stories#index'
end
