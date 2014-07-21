class PlayersController < ApplicationController

	def index
		@players = Player.all
	end

	def show
		@player = Player.find_by last_name: params[:id]
	end

end
