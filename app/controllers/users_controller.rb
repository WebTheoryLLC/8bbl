class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def gamelist
    @games = current_user.gamelist.gamelistgames
  end
  
  def profile
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    
    @genres = ([["Genre", "Quantity of Games"]] + @user.gamelist.popular_genres)
    @platforms = ([["Platform", "Quantity of Platform"]] + @user.gamelist.popular_platforms)
    @developers = ([["Developer", "Quantity of Developer"]] + @user.gamelist.popular_developers)
    
  end

end
