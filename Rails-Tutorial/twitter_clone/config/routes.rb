Rails.application.routes.draw do

  get 'static/home'
  get 'static/help'
  get 'static/about'
  root 'application#hello'
end
