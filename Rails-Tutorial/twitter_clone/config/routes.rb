Rails.application.routes.draw do


  root 'static#home'
  get '/help', to: 'static#help'
  get '/about', to: 'static#about'
  get '/contact', to: 'static#contact'
  get '/signup', to: 'users#new'
end
