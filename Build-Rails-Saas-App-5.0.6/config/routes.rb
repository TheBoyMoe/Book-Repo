Rails.application.routes.draw do
  get 'account/new'

  get 'account/create'

  devise_for :users
  get 'activity/mine'
  get 'activity/feed'
  root to: 'activity#mine'
end
