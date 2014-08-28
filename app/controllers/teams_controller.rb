class TeamsController < ApplicationController
  def index
  		@teams = Team.where("id>1").order(sort_column2 + ' ' + sort_direction)
  		@users = User.all
      @teams.each do |team|
        team.dg=team.gf-team.ga
        team.pts=team.wins*3+team.draws
        team.save
      end


  end

  def show
  	@team = Team.find_by id: params[:id]
		@pj = @team.wins+@team.draws+@team.loses
		@pts = @team.wins*3+@team.draws
		@efectividad = @pts.to_f/(3*@pj)
		@dg = @team.gf-@team.ga
		@gfpp = @team.gf.to_f/@pj.to_f
		@gapp = @team.ga.to_f/@pj.to_f
		@dgpp = @gfpp.to_f-@gapp.to_f
		@user = User.find(@team.user_id)
		@players = Player.where("team_id=?", params[:id]).order(sort_column + ' ' + sort_direction)

  end


  def new
    @users = User.where("id>1")
  end

  def create
  	@users = User.where("id>1")
    user_id = (@users.find_by display_name: params[:user]).id

    @team = Team.new
      @team.name= params[:name]
      @team.user_id=user_id
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
			params.require(:team).permit(:name,:user, :user_id, :country, :gf, :ga, :wins, :draws, :loses, :pts, :dg, :eff)
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


