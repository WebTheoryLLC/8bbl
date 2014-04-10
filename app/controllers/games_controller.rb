class GamesController < ApplicationController
	def create
		@game = Game.where(giantbomb_id: params[:game][:game_id]).first
		current_user.gamelist.gamelistgames.create(game_id: @game.id)
		if params[:game][:platforms]
		  params[:game][:platforms].each do |platform|
		    current_user.gamelist.gamelistgames.where(game_id: @game.id).first.gamelistgameplatforms.create(platform_id: platform)
		  end
		end

		respond_to do |format|
			format.js {}
			format.html {redirect_to search_path(query: params[:game][:query], page: params[:game][:page])}
		end
	end
end
