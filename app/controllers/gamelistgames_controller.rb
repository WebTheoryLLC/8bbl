class GamelistgamesController < ApplicationController
	before_action :authenticate_user!

  def update
		if params[:gamelistgame][:id]
	    @game = Gamelistgame.find(params[:gamelistgame][:id])
	    @game.update_attributes(gamelistgame_params)
		end
		respond_to do |format|
			format.html { redirect_to gamelist_path }
			format.json { render json: {} }
		end
  end

  private

  def gamelistgame_params
    params.require(:gamelistgame).permit(:status)
  end
end
