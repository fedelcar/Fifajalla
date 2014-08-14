class TradesController < ApplicationController
  def new
    current_user = User.find(19)
    @players_user1 = Player.where("user_id=? or id=?", current_user.id, "62302")
    @grouped_players1 = @players_user1.inject({}) do |options, player| 
        (options[Team.find(player.team_id).name] ||= []) << [player.first_name + " " + player.last_name, player.id]
        options
    end

    if (params[:id] == "1")
      @users = User.all
      @grouped_players2 = @grouped_players1
    else
      @users = User.where("id=?", params[:id])
      @user2 = User.find(params[:id])

      @players_user2 = Player.where("user_id=? or id=?", params[:id], "62302")
      @grouped_players2 = @players_user2.inject({}) do |options, player| 
        (options[Team.find(player.team_id).name] ||= []) << [player.first_name + " " + player.last_name, player.id]
        options
    end
    end
    
  	@trades = Trade.all
  	@players = Player.all
  	@teams = Team.all
  end
  
  def onTheBlock
    
  end

  def addToTradeBlock
  	
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
