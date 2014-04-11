class PagesController < ApplicationController
  def index
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
end
