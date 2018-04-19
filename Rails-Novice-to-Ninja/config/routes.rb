Rails.application.routes.draw do

  # singular form of resource - rails creates a singleton of the resource
  resource :session, only: [:create, :new, :destroy]

  resources :stories do
    resources :votes
  end

  root to: 'stories#index'
end
