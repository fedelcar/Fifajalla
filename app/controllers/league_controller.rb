class LeagueController < ApplicationController
  def index
  	@teams = Team.where("id>1 and id<> 35 and id<>37 and id <>34").order(pts: :desc)
  	  @teams.each do |team|
        team.dg=team.gf-team.ga
        team.pts=team.wins*3+team.draws
        team.eff=team.pts/((team.wins+team.draws+team.loses)*3.0)
        team.save
      end
  end

  private


		def sort_column
			params[:sort] || "pts"
		end
		  
		def sort_direction
			params[:direction] || "desc"
		end
end
