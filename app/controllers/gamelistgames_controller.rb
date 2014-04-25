class GamelistgamesController < ApplicationController
	before_action :authenticate_user!

  def update
    @game = Gamelistgame.find(params[:gamelistgame][:id])
    @game.update_attributes(gamelistgame_params)  
  end

  private

  def gamelistgame_params
    params.require(:gamelistgame).permit(:status)
  end
end
