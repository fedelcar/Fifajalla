class TradesController < ApplicationController
  def new
    
    @players_user1 = Player.where("user_id=? or id=?", current_user.id, "1")
    @grouped_players1 = @players_user1.inject({}) do |options, player| 
        (options[Team.find(player.team_id).name] ||= []) << [player.first_name + " " + player.last_name + " " + player.primary_position + " " + player.overall.to_s, player.id]
        options
    end

    if (params[:id] == "1")
      @users = User.where("id<>?",current_user.id)
      @grouped_players2 = @grouped_players1
    else
      @users = User.where("id=?", params[:id])
      @user2 = User.find(params[:id])

      @players_user2 = Player.where("user_id=? or id=?", params[:id], "1")
      @grouped_players2 = @players_user2.inject({}) do |options, player| 
        (options[Team.find(player.team_id).name] ||= []) << [player.first_name + " " + player.last_name + " " + player.primary_position + " " + player.overall.to_s, player.id]
        options
    end
    end
    
  	@trades = Trade.all
  	@players = Player.all
  	@teams = Team.all
  end
  
  def rejectTrade
    @app=Trade_Approval.where("user_id=? and trade_id=?",current_user.id,params[:trade_id]).first
    @user2=((Trade_Approval.where("trade_id=? and user_id<>?",params[:trade_id],current_user.id)).first).user_id
    @trade=Trade.find(@app.trade_id)
    @trade.approvals=@trade.users
    @trade.status="Rejected"
    @trade.save
    UserMailer.trade_rejected(User.find(@user2)).deliver
    redirect_to '/trades/'  
  end

  def my
  if current_user.id==10
    @apps=Trade_Approval.all.order(updated_at: :desc)
  else
    @apps=Trade_Approval.where("user_id=?",current_user.id).order(updated_at: :desc)
  end
  end

  def cancelTrade
    @trade=Trade.find(params[:id])
    @trade.status="Canceled"
    @trade.save

    redirect_to '/trades/my'  
  end



  def approveTrade
    @app=Trade_Approval.where("user_id=? and trade_id=?",current_user.id,params[:trade_id]).first
    @app.approved=true
    @app.save
    @user2=((Trade_Approval.where("trade_id=? and user_id<>?",params[:trade_id],current_user.id)).first).user_id
    @trade=Trade.find(@app.trade_id)
    @trade.approvals=@trade.approvals+1
    @trade.status="Completed"
    @trade.save
    UserMailer.trade_complete(User.find(@user2)).deliver
    if @trade.approvals>=@trade.users
      @pms=Player_Movement.where("trade_id=?",@trade.id)
      @pms.each do |pm|
        @player=Player.find(pm.player_id)
        @player.user_id=pm.second_user_id
        @player.team_id=(Team.find_by user_id: pm.second_user_id).id  
        @player.on_the_block=false
        @player.protected=false
        @player.save
        @pms2=Player_Movement.where("player_id=? and trade_id<>?",@player.id,@trade.id)
        @pm2.each do |pm2|
          @trades=Trade.where("trade_id=? and status='Created'",pm2.trade_id)
          @trades.each do |trade|
            trade.status="Canceled"
            trade.save
          end
        end
      end 
      @pms2=Player_Movement.where("player_id=?",@player.id)

    
    
    end
    redirect_to '/trades/'  
  end


  def proposedTrades
    @approvals=Trade_Approval.where("user_id=? and approved='f'",current_user.id)
  end


  def addToTradeBlock
  	

  end


  def index

    @trades=Trade.where("Status='Completed'").order(id: :desc)


  end


 def create


    @trade = Trade.new
    @trade.status="Created"
    @trade.users=2
    @trade.approvals=1

    @trade.save

    if params[:trade][:player_id_a1] != "1"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_a1]
      @pm.first_user_id=params[:trade][:user_id_a]
      @pm.second_user_id=params[:trade][:user_id_b]
      @pm.first_team_id=Player.find(params[:trade][:player_id_a1]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_b1]).team_id
      @pm.save
    end 

    if params[:trade][:player_id_a2] != "1"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_a2]
      @pm.first_user_id=params[:trade][:user_id_a]
      @pm.second_user_id=params[:trade][:user_id_b]
      @pm.first_team_id=Player.find(params[:trade][:player_id_a2]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_b1]).team_id
      @pm.save
    end

    if params[:trade][:player_id_a3] != "1"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_a3]
      @pm.first_user_id=params[:trade][:user_id_a]
      @pm.second_user_id=params[:trade][:user_id_b]
      @pm.first_team_id=Player.find(params[:trade][:player_id_a3]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_b1]).team_id
      @pm.save
    end

    if params[:trade][:player_id_a4] != "1"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_a4]
      @pm.first_user_id=params[:trade][:user_id_a]
      @pm.second_user_id=params[:trade][:user_id_b]
      @pm.first_team_id=Player.find(params[:trade][:player_id_a4]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_b1]).team_id
      @pm.save
    end

    if params[:trade][:player_id_a5] != "1"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_a5]
      @pm.first_user_id=params[:trade][:user_id_a]
      @pm.second_user_id=params[:trade][:user_id_b]
      @pm.first_team_id=Player.find(params[:trade][:player_id_a5]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_b1]).team_id
      @pm.save
    end

    if params[:trade][:player_id_b1] != "1"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_b1]
      @pm.first_user_id=params[:trade][:user_id_b]
      @pm.second_user_id=params[:trade][:user_id_a]
      @pm.first_team_id=Player.find(params[:trade][:player_id_b1]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_a1]).team_id
      @pm.save
    end 

    if params[:trade][:player_id_b2] != "1"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_b2]
      @pm.first_user_id=params[:trade][:user_id_b]
      @pm.second_user_id=params[:trade][:user_id_a]
      @pm.first_team_id=Player.find(params[:trade][:player_id_b2]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_a1]).team_id
      @pm.save
    end

    if params[:trade][:player_id_b3] != "1"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_b3]
      @pm.first_user_id=params[:trade][:user_id_b]
      @pm.second_user_id=params[:trade][:user_id_a]
      @pm.first_team_id=Player.find(params[:trade][:player_id_b3]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_a1]).team_id
      @pm.save
    end

    if params[:trade][:player_id_b4] != "1"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_b4]
      @pm.first_user_id=params[:trade][:user_id_b]
      @pm.second_user_id=params[:trade][:user_id_a]
      @pm.first_team_id=Player.find(params[:trade][:player_id_b4]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_a1]).team_id
      @pm.save
    end

    if params[:trade][:player_id_b5] != "1"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_b5]
      @pm.first_user_id=params[:trade][:user_id_b]
      @pm.second_user_id=params[:trade][:user_id_a]
      @pm.first_team_id=Player.find(params[:trade][:player_id_b5]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_a1]).team_id
      @pm.save
    end

    @approvalA = Trade_Approval.new
    @approvalA.trade_id=@trade.id
    @approvalA.user_id=params[:trade][:user_id_a]
    @approvalA.approved=true
    @approvalA.save

 
    @approvalB = Trade_Approval.new
    @approvalB.trade_id=@trade.id
    @approvalB.user_id=params[:trade][:user_id_b]
    @approvalB.approved=false
    @approvalB.save
    
    UserMailer.trade_offer(User.find(params[:trade][:user_id_b])).deliver

    redirect_to trades_path


	end

	private
		def trade_params
			params.require(:trade).permit(:player_id, :first_team_id, :first_user_id, :second_team_id, :second_user_id)
		end
end
