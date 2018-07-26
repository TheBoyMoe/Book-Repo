Rails.application.routes.draw do
  devise_for :users
  resource :accounts

  get 'activity/mine'
  get 'activity/feed'

  root to: 'activity#mine'
end
