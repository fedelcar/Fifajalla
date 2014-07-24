class PlayersController < ApplicationController

	def index
		@players = Player.take(1000)
		@path = "players/" 
	end

	def show
		@player = Player.find_by id: params[:id]
		@team = Team.find_by id:@player.team_id
		@user = User.find_by id:@team.user_id
	end
	


end
