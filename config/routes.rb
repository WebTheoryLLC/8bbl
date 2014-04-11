Eightbitbacklog::Application.routes.draw do

  get 'home/index'
  get 'search', to: 'pages#search'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  get "pages/index"

  root 'pages#index'
  
  resource :games
  
  get 'gamelist', to: 'users#gamelist'
  delete 'gamelist', to: 'gamelists#destroy'
  
  get 'profile', to: 'users#profile'
  get "profile/:id", to: "users#profile"
  
end
