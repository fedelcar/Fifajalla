class PlayersController < ApplicationController

	def index
		
			case params[:filter]
				when "def"
					@players = Player.where("primary_position='CB' or primary_position='RB' or primary_position='LB' or primary_position='RWB' or primary_position='LWB'")
				when "med"
					@players = Player.where("primary_position='CDM' or primary_position='CM' or primary_position='LM' or primary_position='RM' or primary_position='CAM'")
				when "fw"
					@players = Player.where("primary_position='CF' or primary_position='ST' or primary_position='LW' or primary_position='RW'")
				when "all"
					@players = Player
				when "drafted"
					@players=Player.where("user_id<>1")
				when "undrafted"
					@players=Player.where("user_id=1")
				when "GK", "RB", "RWB","CB","LB","LWB","CM","CDM","CAM","LM","RM","RW","LW","CF","ST"
					@players = Player.where("primary_position=? or secondary_position=?",params[:filter],params[:filter])
				else					
					@players=Player.where("last_name LIKE ? or first_name LIKE ?",'%'+params[:filter]+'%','%'+params[:filter]+'%')
			end	
			if params[:filter] != "all" and params[:filter] != "drafted"
				@players=@players.where("user_id>=1").take(150)
			else
				@players=@players.take(150)
			end


	end

	def show
		@player = Player.find_by id: params[:id]
		@team = Team.find_by id:@player.team_id
		@user = User.find_by id:@team.user_id
	end

	def search
		
	end

	def releasePlayer
		@rel = Release.new
		@rel.player_id=params[:id]
		@player=Player.find(params[:id])
		@rel.user_id=@player.user_id
		@rel.save

		@teamid=@player.team_id

		@pick=Pick.new
		@pick.user_id=@player.user_id
		@pick.player_id=62302
		@pick.number=Pick.count+1
		@pick.save
		
		@next_pick = Pick.where("player_id=62302").first
		next_pick = Pick.where("player_id=62302").first

		@player.user_id=1
		@player.team_id=1
		@player.on_the_block=false
		@player.protected=false
		@player.save

		if params[:from] == "players"
			redirect_to player_path(@player.id)
		else
			if params[:from] == "trades"	
				redirect_to '/trades/addToTradeBlock'
			else
				redirect_to team_path(@teamid)
			end
		end

	end

	def protectPlayer
		@player=Player.find(params[:id])

		if @player.protected
			@player.protected=false
			@player.save
		else
			if Player.where("team_id=? and protected='t'",@player.team_id).count < 11
				@player.protected=true
				@player.save
			else
			
			end
		end
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

	def stats

		@players = Player.where("games_played>0 and user_id>1").order(sort_column + ' ' + sort_direction).take(1000)
		
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
