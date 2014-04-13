class PagesController < ApplicationController
  include ApplicationHelper

  def index
  end

  def profile
    if params[:username]
      redirect_to root_path, notice: "User Does Not Exist" if User.where(:username => params[:username]).first.nil?
      @user = User.where(:username => params[:username]).first
    else
      redirect_to root_path, notice: "User Does Not Exist" if !user_signed_in?
      @user = current_user
    end
    if @user
      @genres = ([["Genre", "Quantity of Games"]] + @user.gamelist.popular_genres)
      @platforms = ([["Platform", "Quantity of Platform"]] + @user.gamelist.popular_platforms)
      @developers = ([["Developer", "Quantity of Developer"]] + @user.gamelist.popular_developers)
      @status = ([["Status", "Quantity of Games"]] + @user.gamelist.played_stats)
    end
  end


  def search
    if params[:query]
      @page = 1
      @previous = 0
      @next = 2
      @query = params[:query]
      @search = GiantBomb::Search.new
      if params[:page]
		  	@page = params[:page]
		  	@previous = params[:page].to_i - 1
		  	@next = params[:page].to_i + 1
		  	@search.limit(10 * params[:page].to_i) # limits number of returned resources
      else
        @search.limit(10)
      end
      @search.resources('game') # determines type(s) of resources
      @search.fields('id') # limits fields returned
      @search.offset(100) # sets the offset
      @search.query(@query) # the query to search against
      @results = @search.fetch # makes request
      if params[:page]
        @results = @results.last(10)
        if @results.count < 10
          @next = 0
        end
      end

      @temp = []
      @results.each do |result|
        @resultgame = GiantBomb::Game.detail(result["id"])
        if !@resultgame.platforms.nil?
          @resultgame.platforms.each do |platform|
            @platform = Platform.where(name: platform["name"]).first_or_initialize
            if @platform.id.nil?
              @platform.abbr = platform["abbreviation"]
              @platform.save
            end
          end
        end
        @temp.push(@resultgame)
      end
      @results = @temp
  	end
  end

  def stats
    @gamelistgames = Gamelistgame.all

    @top_games = {}
    @top_game_genres = {}
    @top_games_beaten = {}
    @top_game_platforms = {}
    @top_game_developers = {}
    @top_games_playing_now = {}
    @gamelistgames.each do |gamelistgame|
      if @top_games[Game.find(gamelistgame.game_id).name]
        @top_games[Game.find(gamelistgame.game_id).name] += 1
      else
        @top_games[Game.find(gamelistgame.game_id).name] = 1
      end

      Game.find(gamelistgame.game_id).developers.each do |developer|
        if @top_game_developers[developer.name]
          @top_game_developers[developer.name] += 1
        else
          @top_game_developers[developer.name] = 1
        end
      end

      Game.find(gamelistgame.game_id).genres.each do |genre|
        if @top_game_genres[genre.name]
          @top_game_genres[genre.name] += 1
        else
          @top_game_genres[genre.name] = 1
        end
      end

      Game.find(gamelistgame.game_id).platforms.each do |platform|
        if @top_game_platforms[platform.name]
          @top_game_platforms[platform.name] += 1
        else
          @top_game_platforms[platform.name] = 1
        end
      end

      if gamelistgame.status == "Beaten"
        @game = Game.find(gamelistgame.game_id)
        if @top_games_beaten[@game.name]
          @top_games_beaten[@game.name] += 1
        else
          @top_games_beaten[@game.name] = 1
        end
      elsif gamelistgame.status == "In Progress"
        @game = Game.find(gamelistgame.game_id)
        if @top_games_playing_now[@game.name]
          @top_games_playing_now[@game.name] += 1
        else
          @top_games_playing_now[@game.name] = 1
        end
      end
    end

    if @top_games_beaten.count == 0
      @top_games_beaten["No Games Beaten"] = 1
    end

    if @top_games_playing_now.count == 0
      @top_games_playing_now["No Games In Progress Now"] =1
    end

    @top_games             = [["Game", "Quantity of Games"]]      + group_for_graph(@top_games, 8)
    @top_game_genres       = [["Genre", "Quantity of Games"]]     + group_for_graph(@top_game_genres, 8)
    @top_games_beaten      = [["Game", "Quantity of Games"]]      + group_for_graph(@top_games_beaten, 8)
    @top_game_platforms    = [["Platform", "Quantity of Games"]]  + group_for_graph(@top_game_platforms, 8)
    @top_game_developers   = [["Developer", "Quantity of Games"]] + group_for_graph(@top_game_developers, 8)
    @top_games_playing_now = [["Game", "Quantity of Games"]]      + group_for_graph(@top_games_playing_now, 8)
  end
end
