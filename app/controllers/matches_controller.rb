class MatchesController < ApplicationController


  def index
  	@matches = Match.all
  	@users = User.all
  	@teams = Team.all
  end

  def show
	@match = Match.find(params[:id])

	@user_local = User.find(@match.local_user_id)
	@user_visitante = User.find(@match.away_user_id)
	@team_local = Team.find(@match.local_team_id)
	@team_visitante = Team.find(@match.away_team_id)

	@goals = Event.where("match_id=? and event_type_id=2", @match.id)
	@assists = Event.where("match_id=? and event_type_id=3", @match.id)
	@yellow_cards = Event.where("match_id=? and event_type_id=12", @match.id)
	@red_cards = Event.where("match_id=? and (event_type_id=13 or event_type_id=14)", @match.id)
		
	if Event.where("match_id=? and event_type_id=9",@match.id).exists?
		@pom_event = Event.where("match_id=? and event_type_id=9",@match.id)
		@pome = @pom_event.take
		@pomp = Player.find(@pome.player_id)
		@pom=@pomp.first_name + " " + @pomp.last_name
	else
		@pom = ""
	end

	@players_local = Player.where("team_id=?",@team_local.id)
	@players_visitante = Player.where("team_id=?",@team_visitante.id)

  end

  	def update
		@match = Match.find(params[:id])
		#@match = Match.all
		@match.finished = "1"
		@match.save

		redirect_to matches_path
	end

	def create
		@event = Event.new(event_params)

 		@event.player_id = params[:new_event][:player_id]
 		@event.match_id = params[:match_id]

 		if (params[:commit] == "De Jugada")
 			@event.event_type_id=2
 			@event.goal_type_id=0
 		end
 		if (params[:commit] == "De Cabeza")
 			@event.event_type_id=2
 			@event.goal_type_id=0
 		end
 		if (params[:commit] == "De Tiro Libre")
 			@event.event_type_id=2
 			@event.goal_type_id=0
 		end
		if (params[:commit] == "En Contra")
 			@event.event_type_id=2
 			@event.goal_type_id=0
 		end
 		if (params[:commit] == "De Penal")
 			@event.event_type_id=2
 			@event.goal_type_id=0
 		end

 		if (params[:commit] == "Asistencia")
 			@event.event_type_id=3
 		end
 		if (params[:commit] == "Penal Atajado")
 			@event.event_type_id=7
 		end
 		if (params[:commit] == "Amarilla")
 			@event.event_type_id=12
 		end
 		if (params[:commit] == "Roja")
 			@event.event_type_id=14
 		end
 		if (params[:commit] == "Jugador del Partido")
 			@event.event_type_id=9
 		end
 		if (params[:commit] == "Lesión")
 			@event.event_type_id=15
 		end
 	
 		@event.save
		redirect_to edit_match_path(@event.match_id)
	end

  def edit
	@match = Match.find(params[:id])
	@new_event = Event.new

	@users = User.where("id > 1")
	@teams = Team.all

	@home_user = User.find(@match.local_user_id)
	@away_user = User.find(@match.away_user_id)
	@home_team = Team.find(@match.local_team_id)
	@away_team = Team.find(@match.away_team_id)

	# BORRRARR SIGUIENTE
	#@goals = Event.where("match_id=? and event_type_id=2", @match.id)
	#@assists = Event.where("match_id=? and event_type_id=3", @match.id)
	#@yellow_cards = Event.where("match_id=? and event_type_id=12", @match.id)
	#@red_cards = Event.where("match_id=? and (event_type_id=13 or event_type_id=14)", @match.id)

	@match_players = Player.where("team_id=? or team_id=?", @home_team.id, @away_team.id)
	#@match_players.select("teams.id, teams.name").joins(:team_id)
	#@match_players.select("*").joins(:team_id).where(:teams => {u.id => @})
	#@players = @match_players.find(:all, :includes => :teams)
	
	@grouped_players = @match_players.inject({}) do |options, player|
		(options[player.team_id] ||= []) << [player.first_name + " " + player.last_name, player.id]
		options
	end

  end	

	private
		def event_params
			params.permit(:match_id, :player_id, :event_type_id, :goal_type_id)
		end

end
