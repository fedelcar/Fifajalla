class TradesController < ApplicationController
  def new
  	@trades=Trade.all
  	@players = Player.all
  	@teams = Team.all
  	@users = User.all
  end
  
  def onTheBlock
  	
  	@players = Player.all
  end

  def addToTradeBlock
  	@players = Player.all
  end


  def index
  	@trades=Trade.all
  	@players = Player.all
  	@teams = Team.all
  	@users = User.all

  end

	def create
		@trade = Trade.new(trade_params)
 
		@trade.save
		redirect_to trades_path
	end


	private
	
		def trade_params
			params.require(:trade).permit(:player_id, :first_team_id, :first_user_id, :second_team_id, :second_user_id)
		end
end
