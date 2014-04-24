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
    @user_count = User.all.count
    @games_count = Game.all.count
    @genre_count = Genre.all.count
    @concept_count = Concept.all.count
    @platform_count = Platform.all.count
    @developer_count = Developer.all.count

    @games_beaten_count = 0
    @games_in_progress_count = 0

    @gamelistgames = Gamelistgame.all
    @gamelistgames_count = @gamelistgames.count

    @top_games = {}
    @top_game_genres = {}
    @top_games_beaten = {}
    @top_game_platforms = {}
    @top_game_developers = {}
    @top_games_playing_now = {}

    @gamelistgames.each do |gamelistgame|
      @game = Game.find(gamelistgame.game_id)

      @top_games[@game.name] = @top_games[@game.name] ? @top_games[@game.name] + 1 : 1

      @game.developers.each do |developer|
        @top_game_developers[developer.name] = @top_game_developers[developer.name] ? @top_game_developers[developer.name] + 1 : 1
      end

      @game.genres.each do |genre|
        @top_game_genres[genre.name] = @top_game_genres[genre.name] ? @top_game_genres[genre.name] + 1 : 1
      end

      @game.platforms.each do |platform|
        @top_game_platforms[platform.name] = @top_game_platforms[platform.name] ? @top_game_platforms[platform.name] + 1 : 1
      end

      if gamelistgame.status == "Beaten"
        @games_beaten_count += 1
        @top_games_beaten[@game.name] = @top_games_beaten[@game.name] ? @top_games_beaten[@game.name] + 1 : 1
      elsif gamelistgame.status == "In Progress"
        @games_in_progress_count += 1
        @top_games_playing_now[@game.name] = @top_games_playing_now[@game.name] ? @top_games_playing_now[@game.name] + 1 : 1
      end
    end

    @top_games["No Game Stats"] = 1 if @top_games.count == 0
    @top_game_genres["No Genre Stats"] = 1 if @top_game_genres.count == 0
    @top_games_beaten["No Games Beaten"] = 1 if @top_games_beaten.count == 0
    @top_game_platforms["No Platform Stats"] = 1 if @top_game_platforms.count == 0
    @top_game_developers["No Developer Stats"] = 1 if @top_game_developers.count == 0
    @top_games_playing_now["No Games In Progress Now"] = 1 if @top_games_playing_now.count == 0

    @top_games             = [["Game",      "Quantity of Games"]] + group_for_graph(@top_games, 10, false)
    @top_game_genres       = [["Genre",     "Quantity of Games"]] + group_for_graph(@top_game_genres, 10, false)
    @top_games_beaten      = [["Game",      "Quantity of Games"]] + group_for_graph(@top_games_beaten, 10, false)
    @top_game_platforms    = [["Platform",  "Quantity of Games"]] + group_for_graph(@top_game_platforms, 10, false)
    @top_game_developers   = [["Developer", "Quantity of Games"]] + group_for_graph(@top_game_developers, 10, false)
    @top_games_playing_now = [["Game",      "Quantity of Games"]] + group_for_graph(@top_games_playing_now, 10, false)
  end

  def user_signin_up
    if user_signed_in?
      redirect_to root_path
    end
  end
end
