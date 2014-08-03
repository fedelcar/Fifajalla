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
		
	@pom_event = Event.where("match_id=4 and event_type_id=9")
	@pome = @pom_event.take
	@pom = Player.find(@pome.player_id)

	@players_local = Player.where("team_id=?",@team_local.id)
	@players_visitante = Player.where("team_id=?",@team_visitante.id)

  end
	

end
