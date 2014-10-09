class TeamsController < ApplicationController
  def index
<<<<<<< Updated upstream
  		@teams = Team.where("id>1 and id<100").order(sort_column2 + ' ' + sort_direction)
  		@users = User.all
      @teams.each do |team|
        team.dg=team.gf-team.ga
        team.pts=team.wins*3+team.draws
        team.save
=======
  	@teams = Team.where("id>1 and id <100").order(sort_column2 + ' ' + sort_direction)
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


    @teams.each do |team|
      @teamMatches[team.id] = Match.where('local_team_id=? or away_team_id=?',team.id,team.id)
      @pg[team.id] = @teamMatches[team.id].where('(local_team_id=? and local_goals > away_goals) or (away_team_id=? and away_goals > local_goals)',team.id,team.id).count
      @pe[team.id] = @teamMatches[team.id].where('local_goals=away_goals').count
      @pp[team.id] = @teamMatches[team.id].where('(local_team_id=? and local_goals < away_goals) or (away_team_id=? and away_goals < local_goals)',team.id,team.id).count
      @pts[team.id] = @pg[team.id]*3+@pe[team.id]
      @pj[team.id] = @pg[team.id]+@pe[team.id]+@pp[team.id]
      @gf[team.id] = @teamMatches[team.id].where('local_team_id=?',team.id).sum(:local_goals)
      @gf[team.id] += @teamMatches[team.id].where('away_team_id=?',team.id).sum(:away_goals)
      @gc[team.id] = @teamMatches[team.id].where('local_team_id=?',team.id).sum(:away_goals)
      @gc[team.id] += @teamMatches[team.id].where('away_team_id=?',team.id).sum(:local_goals)
      @dg[team.id]=@gf[team.id]-@gc[team.id]
      if @pj[team.id] >0
        @eff[team.id]=@pts[team.id].to_f/(3*@pj[team.id])
      else
        @eff[team.id]=0
>>>>>>> Stashed changes
      end
    end


  end

  def show
  	@team = Team.find_by id: params[:id]
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
		@players = Player.where("team_id=?", params[:id]).order(sort_column + ' ' + sort_direction)


  end


  def new
    @teams = team.where("id>1")
  end

  def create
  	@teams = team.where("id>1")
    team_id = current_team.id

    @team = Team.new
      @team.name= params[:name]
<<<<<<< Updated upstream
      if !Team.exists?(user_id)
        @team.id=user_id
      end
      @team.user_id=user_id
=======
      if !Team.exists?(team_id)
        @team.id=team_id
      end
      @team.team_id=team_id
>>>>>>> Stashed changes
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
