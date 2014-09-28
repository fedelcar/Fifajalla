class MatchesController < ApplicationController


  def index
  	@matches = Match.all.order(finished: :asc).order(updated_at: :desc)
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

	#@players_local = Player.where("user_id=?",@team_local.user_id)
	#@players_visitante = Player.where("user_id=?",@team_visitante.user_id)

  end



def update
	@match = Match.find(params[:id])
	@match.finished = true
	@teamA = Team.find(@match.local_team_id)
	@teamB = Team.find(@match.away_team_id)
	@userA = User.find(@match.local_user_id)
	@userB = User.find(@match.away_user_id)
	@playersa = Player.where("team_id=?",@teamA.id)
	@playersb = Player.where("team_id=?",@teamB.id)
	@playersa.each do |p|
		if p.starting == 't'
			p.games_played=p.games_played+1
			p.save
		end
	end
	@playersb.each do |p|
		if p.starting == 't' 
			p.games_played=p.games_played+1
			p.save
		end
	end
	if @match.local_goals==@match.away_goals
		@scoreA=0.5
		@scoreB=0.5
		@teamA.draws=@teamA.draws+1
		@teamB.draws=@teamB.draws+1
		@userA.draws=@userA.draws+1
		@userB.draws=@userB.draws+1
	else
		if @match.local_goals > @match.away_goals
			@scoreA=1
			@scoreB=0
			@teamA.wins=@teamA.wins+1
			@teamB.loses=@teamB.loses+1
			@userA.wins=@userA.wins+1
			@userB.loses=@userB.loses+1
		else
			@scoreA=0
			@scoreB=1
			@teamB.wins=@teamB.wins+1
			@teamA.loses=@teamA.loses+1
			@userB.wins=@userB.wins+1
			@userA.loses=@userA.loses+1
		end
	end 
	@match.date= Time.now.strftime("%Y/%m/%d")
	@match.time= Time.now.strftime("%H:%M:%S")
	@match.save
	@teamA.save
	@teamB.save

	case @userA.elo
		when ">2400"
			@kA=16
		when ">2100 and <=2400"
			@kA=24
		else
			@kA=32
	end
	case @userB.elo
		when ">2400"
			@kB=16
		when ">2100 and <=2400"
			@kB=24
		else
			@kB=32
	end
	@probA=1.0/(1.0+10.0**-((@userA.elo-@userB.elo)/400.0))
	@probB=1.0/(1.0+10.0**-((@userB.elo-@userA.elo)/400.0))
	@userA.elo=@userA.elo+(@kA*(@scoreA-@probA)).to_i
	@userB.elo=@userB.elo+(@kB*(@scoreB-@probB)).to_i

	@userA.save
	@userB.save


	redirect_to matches_path
end

def newMatch
	if params[:match][:teamL] != params[:match][:teamV]
		@match = Match.new
		@match.local_team_id = (Team.find(params[:match][:teamL])).id
		@match.away_team_id = (Team.find(params[:match][:teamV])).id
		@localUser = User.find(Team.find(@match.local_team_id).user_id).id
		@awayUser = User.find(Team.find(@match.away_team_id).user_id).id
		@match.local_user_id = @localUser
		@match.away_user_id = @awayUser
		@match.local_goals = 0
		@match.away_goals = 0
		@match.finished = false
		@match.date = Time.now.strftime("%Y/%m/%d")
		@match.time = Time.now.strftime("%H:%M:%S")
		@match.elimination = 0
		@match.golden_goal = 0
		@match.local_penalties = 0
		@match.away_penalties = 0
		@match.league_id = (League.find(params[:match][:torneo])).id
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
	
	@event.team_id=@team.id
	@event.user_id=@user.id

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
			@otherTeam.gf = @team.gf+1
			@otherUser.gf = @user.gf+1
			@team.ga = @otherTeam.ga+1
			@user.ga = @otherUser.ga+1
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
		when "Penal Errado"
			@event.event_type_id=16
		when "Cambio"
			@event.event_type_id=17
			if @player.starting == 'f'
				@player.games_played = @player.games_played+1
			end
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

	if @event.event_type_id==2 and @event.goal_type_id != 2
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
	(options[Team.find(player.team_id).name] ||= []) << [player.first_name.to_s + " " + player.last_name, player.id]
	options
end

end	

def new
	@users=User.where("id>1")
	@teams = Team.where("user_id>1").order(wins: :desc)
	@groupedTeams = @teams.inject({}) do |options, team|
		(options[User.find(team.user_id).display_name] ||= []) << [team.name, team.id]
		options
	end
end


private
	def event_params
		params.permit(:match_id, :player_id, :event_type_id, :goal_type_id, :user_id, :team_id)
	end

end
