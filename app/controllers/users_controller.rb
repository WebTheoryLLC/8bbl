class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def gamelist
    @games = current_user.gamelist.gamelistgames
  end
end
