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
	
	def TradeBlock
		@player = Player.find(params[:id])
		if @player.on_the_block=1
			 @player.on_the_block=0
		else
			 @player.on_the_block=1
		end

		@player.save

		if params[:from] == "players"
			redirect_to player_path(@player.id)
		else	
			redirect_to team_path(@player.team_id)
		end
	end

private
  def sort_column
    params[:sort] || "name"
  end
  
  def sort_direction
    params[:direction] || "desc"
  end
end
