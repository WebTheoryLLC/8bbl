class UsersController < ApplicationController
  before_action :authenticate_user!

  def gamelist
    if params[:username]
      @games = Users.where(username: parmas[:username]).first.gamelist.gamelistgames
    else
      @games = current_user.gamelist.gamelistgames
    end
  end
end
