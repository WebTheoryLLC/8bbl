Eightbitbacklog::Application.routes.draw do

  get 'home/index'
  get 'search', to: 'pages#search'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  get "pages/index"

  root 'pages#index'

  resource :games
  resource :gamelistgame
  resource :user
  
  get 'settings', to: 'users#edit'

  get 'gamelist', to: 'users#gamelist'
  get 'gamelist/:username', to: 'users#gamelist'
  delete 'gamelist', to: 'gamelists#destroy'

  get 'profile', to: 'pages#profile'
  get 'profile/:username', to: 'pages#profile'
  get 'stats', to: 'pages#stats'
  
  get 'signin-up', to: 'pages#user_signin_up'

end
