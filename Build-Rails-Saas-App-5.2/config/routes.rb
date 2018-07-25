Rails.application.routes.draw do
  devise_for :users
  get 'test/index'
  get 'activity/mine'
  get 'activity/feed'
  root to: 'activity#mine'
end
