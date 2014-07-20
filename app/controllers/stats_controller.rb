class StatsController < ApplicationController

	def index
		@stats = Stat.all
	end

	def show
		@stat =  Stat.find(params[:id])

		@user = User.find(@stat.user_id)
	end

	def create
		@user = User.find_by name: stat_params[:user]
		@user.create_stat(stat_params.except(:user))

		redirect_to stats_path
	end

	def destroy
		Stat.destroy(params[:id])
		@stats = Stat.all
		
		render 'stats/index'
	end

	private

		def stat_params
			params.require(:stat).permit(:gf, :ga, :wins, :loses, :draws, :user)
		end

end
