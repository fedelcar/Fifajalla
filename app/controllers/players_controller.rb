class PlayersController < ApplicationController

	def index
		@players = Player.take(1000)
		
	end

	def show
		@player = Player.find_by id: params[:id]
		@team = Team.find_by id:@player.team_id
		@user = User.find_by id:@team.user_id
	end
	def stats

		@players = Player.where("goals>0 or assists>0").order(sort_column + ' ' + sort_direction).take(1000)
		
	end
	

private
  def sort_column
    params[:sort] || "name"
  end
  
  def sort_direction
    params[:direction] || "desc"
  end
end
