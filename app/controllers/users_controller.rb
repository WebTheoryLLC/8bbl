class UsersController < ApplicationController
  before_action :authenticate_user!

  def gamelist
    @from_params = false
    if params[:username]
      @user = User.where(:username => params[:username]).first
      redirect_to root_path, notice: "User Does Not Exist" if @user.nil?
      @games = @user.gamelist.gamelistgames
      @from_params = true
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
