Eightbitbacklog::Application.routes.draw do

  get 'home/index'
  get 'search', to: 'pages#search'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  get "pages/index"

  root 'pages#index'
  
  resource :games
  resource :gamelistgame
  
  get 'gamelist', to: 'users#gamelist'
  delete 'gamelist', to: 'gamelists#destroy'
  
  get 'profile', to: 'pages#profile'
  get "profile/:username", to: "pages#profile"
  
end
