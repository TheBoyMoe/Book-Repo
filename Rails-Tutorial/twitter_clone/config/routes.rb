Rails.application.routes.draw do
  get 'static/home'

  get 'static/help'

  root 'application#hello'
end
