class Gamelist < ActiveRecord::Base
  include ApplicationHelper
  belongs_to :user
  has_many   :gamelistgames, dependent: :destroy
  has_many   :games, through: :gamelistgames

  def popular_genres
    @games = self.games
    @genres = Hash.new
    @games.each do |game|
      game.genres.each do |genre|
        if @genres[genre.name].nil?
          @genres[genre.name] = 1
        else
          @genres[genre.name] += 1
        end
      end
    end
    group_for_graph(@genres)
  end

  def popular_platforms
    @games = self.gamelistgames
    @platforms = Hash.new
    @games.each do |game|
      game.platforms.each do |platform|
        if @platforms[platform.name].nil?
          @platforms[platform.name] = 1
        else
          @platforms[platform.name] += 1
        end
      end
    end
    group_for_graph(@platforms)
  end

  def popular_developers
    @games = self.games
    @developers = Hash.new
    @games.each do |game|
      game.developers.each do |developer|
        if @developers[developer.name].nil?
          @developers[developer.name] = 1
        else
          @developers[developer.name] += 1
        end
      end
    end
    group_for_graph(@developers)
  end

  def played_stats
    @stats = []
    @stats.push(["Beaten", self.gamelistgames.where(status: "Beaten").count])
    @stats.push(["In Progress", self.gamelistgames.where(status: "In Progress").count])
    @stats.push(["Have not Played", self.gamelistgames.where(status: "Have not Played").count])
    @stats
  end

  def suggested_games
    @concepts = {}
    self.gamelistgames.each do |gamelistgame|
      gamelistgame.game.concepts.each do |concept|
        @concepts[concept.name] = @concepts[concept.name] ? @concepts[concept.name] + 1 : 1
      end
    end
    @data = Hash[@concepts.sort_by {|_, v| v}.reverse]

    @data_per_game = {}
    @data.first(10).each do |key, _|
      @data_per_game[key] = Game.includes(:concepts).where(concepts: {name: key}).count
    end
    @data_per_game = Hash[@data_per_game.sort_by {|_, v| v}.reverse]

    @suggestions = []
    @data_per_game.each do |key, _|
      Game.includes(:concepts).where(concepts: {name: key}).first(2).each do |game|
        @suggestions.push(game) if !@suggestions.include?(game)
      end
    end
    @suggestions = @suggestions ? @suggestions : []

    @giantbomb_suggestions = []
    @suggestions.each do |suggestion|
      puts "[suggestion] #{suggestion}"
      @resultgame = GiantBomb::Game.detail(suggestion.giantbomb_id)
      @count = 2
      if !@resultgame.similar_games.nil?
        @similar_games = similar_games(@resultgame, @count)
        while @similar_games.count == 0 do
          @count = @count + 1
          @similar_games = similar_games(@resultgame, @count)
        end
        @similar_games.each do |game|
          @giantbomb_suggestions = @giantbomb_suggestions + game if !@giantbomb_suggestions.include?(game)
        end
      end
    end
    @giantbomb_suggestions
  end

  private

  def similar_games(resultgame, count)
    @giantbomb_suggestions = []
    resultgame.similar_games.first(count+1).each do |game|
      @game = {}
      @game["giantbomb_id"] = game["id"]
      @game["name"] = game["name"]
      if Game.find_by_giantbomb_id(@game["giantbomb_id"])
        @giantbomb_suggestions.push(@game) if !self.games.include?(Game.find_by_giantbomb_id(@game["giantbomb_id"]))
      else
        @giantbomb_suggestions.push(@game)
      end
    end
    @giantbomb_suggestions
  end
end
