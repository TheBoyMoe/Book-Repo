Rails.application.routes.draw do
  get 'test/index'
  get 'activity/mine'
  get 'activity/feed'
  root to: 'activity#mine'
end
