Rails.application.routes.draw do

  # singular form of resource - rails creates a singleton of the resource
  resource :session, only: [:create, :new, :destroy]
  
  resources :users, only: [:show]

  resources :stories do
    collection do
      get 'bin'
    end
    resources :votes
  end

  root to: 'stories#index'
end
