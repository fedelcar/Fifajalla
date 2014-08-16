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
  
  def rejectTrade
    @app=Trade_Approval.where("user_id=? and trade_id=?",current_user.id,params[:trade_id]).first
    @trade=Trade.find(@app.trade_id)
    @trade.approvals=@trade.users
    @trade.status="Rejected"
    @trade.save
    redirect_to '/trades/'  
  end


  def approveTrade
    @app=Trade_Approval.where("user_id=? and trade_id=?",current_user.id,params[:trade_id]).first
    @app.approved=true
    @app.save
    @trade=Trade.find(@app.trade_id)
    @trade.approvals=@trade.approvals+1
    @trade.status="Completed"
    @trade.save
    if @trade.approvals=@trade.users
      @pms=Player_Movement.where("trade_id=?",@trade.id)
      @pms.each do |pm|
        @player=Player.find(pm.player_id)
        @player.user_id=pm.second_user_id
        @player.team_id=(Team.find_by user_id: pm.second_user_id).id  
        @player.save
      end 
    else
    end
    redirect_to '/trades/'  
  end


  def proposedTrades
    @approvals=Trade_Approval.where("user_id=? and approved='f'",current_user.id)
  end


  def addToTradeBlock
  	

  end


  def index

    @trades=Trade.where("Status='Completed'")


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
