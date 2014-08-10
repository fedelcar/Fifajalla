class PlayersController < ApplicationController

	def index
			case params[:filter]
				when "def"
					@players = Player.where("primary_position='CB' or primary_position='RB' or primary_position='LB' or primary_position='RWB' or primary_position='LWB'").take(150)
				when "med"
					@players = Player.where("primary_position='CDM' or primary_position='CM' or primary_position='LM' or primary_position='RM' or primary_position='CAM'").take(150)
				when "fw"
					@players = Player.where("primary_position='CF' or primary_position='ST' or primary_position='LW' or primary_position='RW'").take(150)
				when "all"
					@players = Player.take(1000)
				else
					@players = Player.where("primary_position=? or secondary_position=?",params[:filter],params[:filter]).take(150)
			end	
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
		if @player.on_the_block
			 @player.on_the_block=0
		else
			 @player.on_the_block=1
		end

		@player.save

		if params[:from] == "players"
			redirect_to player_path(@player.id)
		else
			if params[:from] == "trades"	
				redirect_to '/trades/addToTradeBlock'
			else
				redirect_to team_path(@player.team_id)
			end
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
