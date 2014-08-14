class LeagueController < ApplicationController
  def index
  	@teams = Team.where("id>1")
  end

  private


		def sort_column
			params[:sort] || "pts"
		end
		  
		def sort_direction
			params[:direction] || "desc"
		end
end
