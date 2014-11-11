class TeamsController < ApplicationController
  def index
  	@teams = Team.where("id>1 and id <100")
    @teamMatches = Array.new
    @pg = Array.new
    @pe = Array.new
    @pp = Array.new
    @pts = Array.new
    @pj = Array.new
    @gf = Array.new
    @gc = Array.new
    @dg = Array.new
    @eff = Array.new
    @amarillas = Array.new
    @rojas = Array.new
    @list = Array.new
    @categories = Array.new
    @categories = ["Equipo","Usuario","PJ","PG","PE","PP","Pts","Eff","GF","GC","DG","Amarillas","Rojas"]


    @teams.each do |team|
      @teamMatches = Match.where('local_team_id=? or away_team_id=?',team.id,team.id)
      @pg = @teamMatches.where('(local_team_id=? and local_goals > away_goals) or (away_team_id=? and away_goals > local_goals)',team.id,team.id).count
      @pe = @teamMatches.where('local_goals=away_goals').count
      @pp = @teamMatches.where('(local_team_id=? and local_goals < away_goals) or (away_team_id=? and away_goals < local_goals)',team.id,team.id).count
      @pts = @pg*3+@pe
      @pj = @pg+@pe+@pp
      @gf = @teamMatches.where('local_team_id=?',team.id).sum(:local_goals)
      @gf += @teamMatches.where('away_team_id=?',team.id).sum(:away_goals)
      @gc = @teamMatches.where('local_team_id=?',team.id).sum(:away_goals)
      @gc += @teamMatches.where('away_team_id=?',team.id).sum(:local_goals)
      @dg=@gf-@gc
      if @pj >0
        @eff=(@pts.to_f/(3*@pj))*100
      else
        @eff=0
      end
      @amarillas= Event.where("team_id=? and event_type_id=12",team.id).count
      @rojas= Event.where("team_id=? and event_type_id=14",team.id).count

      @user = User.find(team.user_id).display_name
      @teamArray = [team.name,@user,@pj,@pg,@pe,@pp,@pts,@eff,@gf,@gc,@dg,@amarillas,@rojas]

      @list.push(@teamArray)
    end

    @sortedList = Array.new
    @sortedList = sortList(@categories,params[:sort],@list)


  end

  def show


  	@team = Team.find_by id: params[:id]
    @categories = Array.new
    @categories = ["Nombre","Overall","Pos","Goles","Asistencias","Titular","Tradeable","Protegido"]


    @teamMatches = Match.where('local_team_id=? or away_team_id=?',params[:id],params[:id])
    @pg = @teamMatches.where('(local_team_id=? and local_goals > away_goals) or (away_team_id=? and away_goals > local_goals)',params[:id],params[:id]).count
    @pe = @teamMatches.where('local_goals=away_goals').count
    @pp = @teamMatches.where('(local_team_id=? and local_goals < away_goals) or (away_team_id=? and away_goals < local_goals)',params[:id],params[:id]).count
    @pts = @pg*3+@pe
    @pj = @pg+@pe+@pp
    @gf = @teamMatches.where('local_team_id=?',params[:id]).sum(:local_goals)
    @gf += @teamMatches.where('away_team_id=?',params[:id]).sum(:away_goals)
    @gc = @teamMatches.where('local_team_id=?',params[:id]).sum(:away_goals)
    @gc += @teamMatches.where('away_team_id=?',params[:id]).sum(:local_goals)
    @dg=@gf-@gc
    if @pj >0
      @efectividad=@pts.to_f/(3*@pj)
    else
      @efectividad=0
    end

		@gfpp = @gf.to_f/@pj.to_f
		@gcpp = @gc.to_f/@pj.to_f
		@dgpp = @gfpp.to_f-@gcpp
		@team = Team.find(params[:id])
    @user = User.find(@team.user_id)
		@players = Player.where("team_id=?", params[:id])
    @goals = Array.new

    @list = Array.new
    @players.each do |player|
      @goals=Event.where("player_id=? and event_type_id=2 and goal_type_id<>2 and team_id<500",player.id).count
      @asistencias=Event.where("player_id=? and event_type_id=3 and team_id<500",player.id).count
      @teamArray = [player.first_name+ ' ' +player.last_name,player.overall,player.primary_position,@goals,@asistencias,player.starting,player.on_the_block,player.protected,player.id,player.user_id]
      @list.push(@teamArray)
    end

    @players = sortList(@categories,params[:sort],@list)
  end


  def new
    @teams = Team.where("id>1")
  end

  def create
  	@teams = Team.where("id>1")
    team_id = current_team.id

    @team = Team.new
      @team.name= params[:name]
      if !Team.exists?(team_id)
        @team.id=team_id
      end
      @team.team_id=team_id
 			@team.country=0
 			@team.gf=0
 			@team.ga=0
 			@team.wins=0
 			@team.draws=0
 			@team.loses=0
 			@team.pts=0
 			@team.dg=0
 			@team.eff=0
 			@team.save
		redirect_to team_path(@team.id)
  end

private

  def team_params
			params.require(:team).permit(:name,:team, :team_id, :country, :gf, :ga, :wins, :draws, :loses, :pts, :dg, :eff)
  end

  def sort_column
    params[:sort] || "overall"
  end

  def sort_column2
    params[:sort] || "pts"
  end

  def sort_direction
    params[:direction] || "desc"
  end
end
