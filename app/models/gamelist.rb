class Gamelist < ActiveRecord::Base
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
    @genres = Hash[@genres.sort_by {|_, v| v}.reverse]
    @others = @genres
    @genres.first(5).each do |genre|
      @others = @others.except(genre.first)
    end
    if @others.count > 1
      @genres = @genres.first(5).push(["Others", 0]) 
      @others.to_a.each do |other|
        @other = @genres.pop
        @other[1] += other.last
        @genres.push(@other)
      end      
    end
    @genres.to_a
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
    @platforms = Hash[@platforms.sort_by {|_, v| v}.reverse]    
    @others = @platforms
    @platforms.first(5).each do |platform|
      @others = @others.except(platform.first)
    end
    if @others.count > 1
      @platforms = @platforms.first(5).push(["Others", 0])
      @others.to_a.each do |other|
        @other = @platforms.pop
        @other[1] += other.last
        @platforms.push(@other)
      end
    end
    @platforms.to_a
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
    @developers = Hash[@developers.sort_by {|_, v| v}.reverse]
    @others = @developers
    @developers.first(5).each do |developer|
      @others = @others.except(developer.first)
    end
    if @others.count > 1
      @developers = @developers.first(5).push(["Others", 0])
      @others.to_a.each do |other|
        @other = @developers.pop
        @other[1] += other.last
        @developers.push(@other)
      end
    end
    @developers.to_a
  end
  
  def played_stats
    @stats = []
    @stats.push(["Beaten", self.gamelistgames.where(status: "Beaten").count])
    @stats.push(["In Progress", self.gamelistgames.where(status: "In Progress").count])
    @stats.push(["Have not Played", self.gamelistgames.where(status: "Have not Played").count])
    @stats
  end
end
