class GamelistgamesController < ApplicationController
	before_action :authenticate_user!

  def update
    @game = Gamelistgame.find(params[:gamelistgame][:id])
    @game.update_attributes(gamelistgame_params)
    # redirect_to gamelist_path  
  end

  private

  def gamelistgame_params
    params.require(:gamelistgame).permit(:status)
  end
end
