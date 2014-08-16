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

	@goals = Event.where("match_id=? and event_type_id=2 and goal_type_id<>2", @match.id)
	@ownGoals = Event.where("match_id=? and event_type_id=2 and goal_type_id=2", @match.id)
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
	@match.finished = true
	@teamA = Team.find(@match.local_team_id)
	@teamB = Team.find(@match.away_team_id)
	@userA = User.find(@match.local_user_id)
	@userB = User.find(@match.away_user_id)
	if @match.local_goals==@match.away_goals
		@teamA.draws=@teamA.draws+1
		@teamB.draws=@teamB.draws+1
		@userA.draws=@userA.draws+1
		@userB.draws=@userB.draws+1
	else
		if @match.local_goals > @match.away_goals
			@teamA.wins=@teamA.wins+1
			@teamB.loses=@teamB.loses+1
			@userA.wins=@userA.wins+1
			@userB.loses=@userB.loses+1
		else
			@teamB.wins=@teamB.wins+1
			@teamA.loses=@teamA.loses+1
			@userB.wins=@userB.wins+1
			@userA.loses=@userA.loses+1
		end
	end 
	@playersA=Player.where("team_id=?",@teamA.id)
	@playersB=Player.where("team_id=?",@teamB.id)
	@playersA.each do |player|
		player.games_played=player.games_played+1
		player.save
	end
	@playersB.each do |player|
		player.games_played=player.games_played+1
		player.save
	end
	@match.save
	@teamA.save
	@teamB.save
	@userA.save
	@userB.save


	redirect_to matches_path
end

def newMatch
	if params[:userL] != params[:userV]
		@match = Match.new
		@localUser=User.find_by display_name: params[:userL]
		@awayUser=User.find_by display_name: params[:userV]
		@match.local_user_id=@localUser.id
		@match.away_user_id=@awayUser.id
		@match.local_goals=0
		@match.away_goals=0
		@match.local_team_id=(Team.find_by user_id: @localUser.id).id
		@match.away_team_id=(Team.find_by user_id: @awayUser.id).id
		@match.finished=false
		
		@match.date= Time.now.strftime("%Y/%m/%d")
		@match.time= Time.now.strftime("%H:%M:%S")
		@match.elimination=0
		@match.golden_goal=0
		@match.local_penalties=0
		@match.away_penalties=0
		@match.save
		redirect_to edit_match_path(@match.id)
	else
		redirect_to '/matches/new'
	end
end


def createEvent
	@event = Event.new(event_params)
	@match = Match.find(params[:match_id])
	@player = Player.find(params[:new_event][:player_id])
	@team = Team.find(@player.team_id)
	@user= User.find(@player.user_id)
	
	if @match.local_user_id == @user.id
		@otherUser = User.find(@match.away_user_id)
		@otherTeam = Team.find(@match.away_team_id)
	else
		@otherUser = User.find(@match.local_user_id)
		@otherTeam = Team.find(@match.local_team_id)
	end

	case params[:commit]
		when "De Jugada"
			@event.event_type_id=2
			@event.goal_type_id=1
		when "De Cabeza"
			@event.event_type_id=2
			@event.goal_type_id=5
		when "De Tiro Libre"
			@event.event_type_id=2
			@event.goal_type_id=4
		when "En Contra"
			@event.event_type_id=2
			@event.goal_type_id=2
			@player.own_goals=@player.own_goals+1
			@otherTeam.gf = @otherTeam.gf+1
			@otherUser.gf = @otherUser.gf+1
			@team.ga = @team.ga+1
			@user.ga = @user.ga+1
			if @match.local_user_id == @user.id
				@match.away_goals=@match.away_goals+1
			else
				@match.local_goals=@match.local_goals+1
			end
		when "De Penal"
			@event.event_type_id=2
			@event.goal_type_id=3
		when "Asistencia"
			@event.event_type_id=3
			@player.assists=@player.assists+1
		when "Penal Atajado"
			@event.event_type_id=7
		when "Amarilla"
			if Event.where("match_id=? and player_id=? and event_type_id=12",@match.id,@player.id).count<=1
				@event.event_type_id=12
				@player.yellow_cards=@player.yellow_cards+1
			end
		when "Roja"
			if Event.where("match_id=? and player_id=? and event_type_id=14",@match.id,@player.id).count==0
				@event.event_type_id=14		
				@player.red_cards=@player.red_cards+1
			end
		when "Jugador del Partido"
			@event.event_type_id=9	
		when "Lesión"
			@event.event_type_id=15
	end

	if (@event.event_type_id==2) and (@event.goal_type_id != 2)
		@team.gf = @team.gf+1
		@user.gf = @user.gf+1
		@player.goals=@player.goals+1
		@otherTeam.ga = @otherTeam.ga+1
		@otherUser.ga = @otherUser.ga+1
		if @match.local_user_id == @user.id
			@match.local_goals=@match.local_goals+1
		else
			@match.away_goals=@match.away_goals+1
		end
	end

		@event.player_id = params[:new_event][:player_id]
		@event.match_id = params[:match_id]
		@event.save
		@player.save
		@user.save
		@team.save
		@otherUser.save
		@otherTeam.save
		@match.save

	
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

@match_players = Player.where("team_id=? or team_id=?", @home_team.id, @away_team.id)


@grouped_players = @match_players.inject({}) do |options, player|
	(options[Team.find(player.team_id).name] ||= []) << [player.first_name + " " + player.last_name, player.id]
	options
end

end	

def new
	@users=User.where("id>1")
end


private
	def event_params
		params.permit(:match_id, :player_id, :event_type_id, :goal_type_id)
	end

end
