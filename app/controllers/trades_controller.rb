class TradesController < ApplicationController
  def new
  end
  
  def onTheBlock
  	
  	@players = Player.all
  end

  def addToTradeBlock
  	@players = Player.all
  end


  def index
  	@trades=Trade.all
  end

	def create
		@trade = Trade.new(trade_params)
 
		@trade.save
		redirect_to trades_path
	end


	private
	
		def trade_params
			params.require(:trade).permit(:player_id, :first_team_id)
		end
end
