class TeamsController < ApplicationController
  def index
  		@teams = Team.where("id>1").order(sort_column + ' ' + sort_direction)
  		@users = User.all

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
  end

private
  def sort_column
    params[:sort] || "id"
  end
  
  def sort_direction
    params[:direction] || "desc"
  end
end


