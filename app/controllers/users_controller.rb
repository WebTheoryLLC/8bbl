class UsersController < ApplicationController
  before_action :authenticate_user!

  def gamelist
    if params[:username]
      redirect_to root_path, notice: "User Does Not Exist" if User.where(:username => params[:username]).first.nil?
      @games = User.where(username: params[:username]).first.gamelist.gamelistgames
    else
      @games = current_user.gamelist.gamelistgames
    end
    if user_signed_in?
      @giantbomb_suggestions = current_user.gamelist.suggested_games
    end
  end
  
  def edit
    @user = current_user  
  end
  
  def update
    @user = current_user
    @user.update_attributes(user_params)
    redirect_to settings_path, notice: "Updated Settings!"
  end
  
  private
  
  def user_params 
    params.require(:user).permit(:username, :first_name, :last_name, :bio, :twitter_handle, :giant_bomb_handle, :twitch_handle, :email)
  end
  
end
