class Steam
  include HTTParty
  debug_output $stderr
  base_uri 'http://api.steampowered.com'
  attr_reader :params, :steam_id

  def initialize(id)
    @steam_id = id
  end

  def games
    @params = { :query => {:key => ENV["STEAM_KEY"], :steamid => @steam_id, :include_appinfo => 1, :include_played_free_games => 1, :format => "json"} }
    self.class.get("/IPlayerService/GetOwnedGames/v0001/", @params)
  end
end
