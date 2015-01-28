class PlayersController < ApplicationController

	def index
		@nations = Player.order(nation: :asc).uniq.pluck(:nation)
		@leagues = Player.order(league: :asc).uniq.pluck(:league)

		case params[:filter1]
			when "def"
				@players = Player.where("primary_position='CB' or primary_position='RB' or primary_position='LB' or primary_position='RWB' or primary_position='LWB'")
			when "med"
				@players = Player.where("primary_position='CDM' or primary_position='CM' or primary_position='LM' or primary_position='RM' or primary_position='CAM'")
			when "fw"
				@players = Player.where("primary_position='CF' or primary_position='ST' or primary_position='LW' or primary_position='RW'")
			when "GK", "RB", "RWB","CB","LB","LWB","CM","CDM","CAM","LM","RM","RW","LW","CF","ST"
				@players = Player.where("primary_position=? or secondary_position=?",params[:filter1],params[:filter1])
			when "all"
				@players = Player.all
			else
				@players = Player.where("first_name LIKE ? or last_name LIKE ?",params[:filter1],params[:filter1])

		end
		
		case params[:filter2]
			when "drafted"
				@players= @players.where("user_id>1")
			when "undrafted"
				@players= @players.where("user_id=1")
		end		
		
		if params[:filter3] != "all" and params[:filter3] != nil
			@players=@players.where("league=?",params[:filter3])
		end

		if params[:filter4] != "all" and params[:filter3] != nil
			@players=@players.where("nation=?",params[:filter4])
		end

		@players=@players.where("id>1").order(overall: :desc).take(150)

	end


	def movePlayer
		@team = Team.find(params[:movePlayer][:team])
		@pm = Player_Movement.new
		@player=Player.find(params[:id])
      	@pm.player_id=@player.id
      	@pm.first_user_id=@player.user_id
      	@player.user_id=@team.user_id
      	@pm.second_user_id=@player.user_id
      	@pm.first_team_id=@player.team_id
      	@pm.second_team_id=params[:movePlayer][:team]
      	@pm.save
      	@player.team_id=params[:movePlayer][:team]
      	@player.save

		redirect_to player_path(params[:id])
	end

	def show
		@player = Player.find(params[:id])
		@team = Team.find_by id:@player.team_id
		@user = User.find_by id:@team.user_id
		@attributeNames = Array.new
		@attributes = Array.new
		if @player.primary_position == "GK"
			@attributeNames.push("Handling", "Kicking", "Diving", "Positioning", "Reflexes")
			@attributes.push(@player.handling, @player.kicking, @player.diving, @player.positioning, @player.reflexes)
		else
			@attributeNames.push("Ball Control", "Crossing", "Curve", "Dribbling", "Finishing", "Free Kick Acc.", "Heading", "Long Pass", "Long Shots", "Marking", "Penalties", "Short Pass", "Shot Power", "Sliding Tackle", "Standing Tackle", "Volleys", "Acceleration", "Agility", "Balance", "Jumping", "Reactions", "Sprint Speed", "Stamina", "Strength", "Aggresion", "Positioning", "Interceptions", "Vision")
			@attributes.push(@player.ball_control, @player.crossing, @player.curve, @player.dribbling_skill, @player.finishing, @player.free_kick_accuracy, @player.heading_accuracy, @player.long_passing, @player.long_shots, @player.marking, @player.penalties, @player.short_passing, @player.shot_power, @player.sliding_tackle, @player.standing_tackle, @player.volleys, @player.acceleration, @player.agility, @player.balance, @player.jumping, @player.reactions, @player.sprint_speed, @player.stamina, @player.strength, @player.aggression, @player.positioning, @player.interceptions, @player.vision)
		end



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
		@pick.player_id=1
		@pick.number=Pick.count+1
		@pick.draft_id=4
		@pick.save

		@next_pick = Pick.where("player_id=1").first
		next_pick = Pick.where("player_id=1").first

		@player.user_id=1
		@player.team_id=1
		@player.on_the_block=false
		@player.protected=false
		@player.starting=false
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

	def hacerTitular
		@player=Player.find(params[:id])

		if @player.starting
			@player.starting=false
			@player.save
		else
			if Player.where("team_id=? and starting='t'",@player.team_id).count < 11
				@player.starting=true
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

		@players = Player.where("games_played>3 and user_id>1")
		@playersWithEvents=Array.new
		@players.each do |player|
			if Event.exists?(player_id: player.id)
				@playersWithEvents.push(player)
			end
		end

		@list = Array.new
		@categories = Array.new
		@categories = ["ID", "IDEquipo","Nombre","Equipo","PJ","Goles","Promedio_de_gol", "Asistencias", "Amarillas", "Rojas", "POM", "De_jugada", "En_contra", "De_cabeza", "De_tiro_libre", "De_penal", "Penales_errados","Penales_atajados"]

		@playersWithEvents.each do |player|
			@playerEvents=Event.where("player_id=? and team_id<500",player.id)
		 	@goals=@playerEvents.where("event_type_id=2 and goal_type_id<>2",player.id).count
		 	@assists=@playerEvents.where("event_type_id=3",player.id).count
		 	@amarillas=@playerEvents.where("event_type_id=12",player.id).count
		 	@rojas=@playerEvents.where("event_type_id=14",player.id).count
			@enContra=@playerEvents.where("event_type_id=2 and goal_type_id=2",player.id).count
		 	@POM=@playerEvents.where("event_type_id=9",player.id).count
		 	@deJugada=@playerEvents.where("event_type_id=2 and goal_type_id=1",player.id).count
		 	@dePenal=@playerEvents.where("event_type_id=2 and goal_type_id=3",player.id).count
		 	@deTiroLibre=@playerEvents.where("event_type_id=2 and goal_type_id=4" ,player.id).count
		 	@deCabeza=@playerEvents.where("event_type_id=2 and goal_type_id=5",player.id).count
		 	@errados=@playerEvents.where("event_type_id=16",player.id).count
			@atajados=@playerEvents.where("event_type_id=7",player.id).count
			@playerArray = [player.id,player.team_id,player.first_name+ ' ' + player.last_name,Team.find(player.team_id).name,player.games_played,@goals,@goals/player.games_played.to_f,@assists,@amarillas, @rojas, @POM,@deJugada,@enContra,@deCabeza,@deTiroLibre, @dePenal,@errados,@atajados ]
			@list.push(@playerArray)
		end

		@players = sortList(@categories,params[:sort],@list)

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
