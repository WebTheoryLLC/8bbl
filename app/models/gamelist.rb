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
end
