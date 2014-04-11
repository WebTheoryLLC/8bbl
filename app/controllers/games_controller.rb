class GamesController < ApplicationController
	before_action :authenticate_user!
	def create
    @game = Game.where(giantbomb_id: params[:game][:game_id]).first_or_initialize
    if @game.id.nil?
      @resultgame = GiantBomb::Game.detail(params[:game][:game_id])
      @game.name = @resultgame.name
      @game.deck = @resultgame.deck
      @game.save
  
      if !@resultgame.platforms.nil?
        @resultgame.platforms.each do |platform|
          @platform = Platform.where(name: platform["name"]).first_or_initialize
          if @platform.id.nil?
            @platform.abbr = platform["abbreviation"]
            @platform.save
          end
  
          @game.gameplatforms.create(platform_id: @platform.id)
        end
      end
  
      if !@resultgame.genres.nil?
        @resultgame.genres.each do |genre|
          @genre = Genre.where(name: genre["name"]).first_or_create
          @game.gamegenres.create(genre_id: @genre.id)
        end
      end
  
      if !@resultgame.concepts.nil?
        @resultgame.concepts.each do |concept|
          @concept = Concept.where(name: concept["name"]).first_or_create
          @game.gameconcepts.create(concept_id: @concept.id)
        end
      end
  
      if !@resultgame.developers.nil?
        @resultgame.developers.each do |developer|
          @developer = Developer.where(name: developer["name"]).first_or_create
          @game.gamedevelopers.create(developer_id: @developer.id)
        end
      end
  
      if !@resultgame.publishers.nil?
        @resultgame.publishers.each do |publisher|
          @publisher = Publisher.where(name: publisher["name"]).first_or_create
          @game.gamepublishers.create(publisher_id: @publisher.id)
        end
      end
    end

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
