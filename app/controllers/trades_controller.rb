class TradesController < ApplicationController
  def new
    
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

  def proposedTrades
    
  end


  def index
    @trades=Trade.where("users=approvals")
    @players = Player.all
    @teams = Team.all
    @users = User.all
  end

  def create

    @trade = Trade.new
    @trade.status="Created"
    @trade.users=2
    @trade.approvals=1

    
 

    @trade.save

    if params[:trade][:player_id_a1] != "62302"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_a1]
      @pm.first_user_id=params[:trade][:user_id_a]
      @pm.second_user_id=params[:trade][:user_id_b]
      @pm.first_team_id=Player.find(params[:trade][:player_id_a1]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_b1]).team_id
      @pm.save
    end 

    if params[:trade][:player_id_a2] != "62302"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_a2]
      @pm.first_user_id=params[:trade][:user_id_a]
      @pm.second_user_id=params[:trade][:user_id_b]
      @pm.first_team_id=Player.find(params[:trade][:player_id_a2]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_b2]).team_id
      @pm.save
    end

    if params[:trade][:player_id_a3] != "62302"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_a3]
      @pm.first_user_id=params[:trade][:user_id_a]
      @pm.second_user_id=params[:trade][:user_id_b]
      @pm.first_team_id=Player.find(params[:trade][:player_id_a3]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_b3]).team_id
      @pm.save
    end

    if params[:trade][:player_id_a4] != "62302"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_a4]
      @pm.first_user_id=params[:trade][:user_id_a]
      @pm.second_user_id=params[:trade][:user_id_b]
      @pm.first_team_id=Player.find(params[:trade][:player_id_a4]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_b4]).team_id
      @pm.save
    end

    if params[:trade][:player_id_a5] != "62302"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_a5]
      @pm.first_user_id=params[:trade][:user_id_a]
      @pm.second_user_id=params[:trade][:user_id_b]
      @pm.first_team_id=Player.find(params[:trade][:player_id_a5]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_b5]).team_id
      @pm.save
    end

    if params[:trade][:player_id_b1] != "62302"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_b1]
      @pm.first_user_id=params[:trade][:user_id_b]
      @pm.second_user_id=params[:trade][:user_id_a]
      @pm.first_team_id=Player.find(params[:trade][:player_id_b1]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_a1]).team_id
      @pm.save
    end 

    if params[:trade][:player_id_b2] != "62302"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_b2]
      @pm.first_user_id=params[:trade][:user_id_b]
      @pm.second_user_id=params[:trade][:user_id_a]
      @pm.first_team_id=Player.find(params[:trade][:player_id_b2]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_a2]).team_id
      @pm.save
    end

    if params[:trade][:player_id_b3] != "62302"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_b3]
      @pm.first_user_id=params[:trade][:user_id_b]
      @pm.second_user_id=params[:trade][:user_id_a]
      @pm.first_team_id=Player.find(params[:trade][:player_id_b3]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_a3]).team_id
      @pm.save
    end

    if params[:trade][:player_id_b4] != "62302"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_b4]
      @pm.first_user_id=params[:trade][:user_id_b]
      @pm.second_user_id=params[:trade][:user_id_a]
      @pm.first_team_id=Player.find(params[:trade][:player_id_b4]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_a4]).team_id
      @pm.save
    end

    if params[:trade][:player_id_b5] != "62302"
      @pm=Player_Movement.new
      @pm.trade_id=@trade.id
      @pm.player_id=params[:trade][:player_id_b5]
      @pm.first_user_id=params[:trade][:user_id_b]
      @pm.second_user_id=params[:trade][:user_id_a]
      @pm.first_team_id=Player.find(params[:trade][:player_id_b5]).team_id
      @pm.second_team_id=Player.find(params[:trade][:player_id_a5]).team_id
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

    redirect_to trades_path
  end

  private
    def trade_params
      params.require(:trade).permit(:player_id, :first_team_id, :first_user_id, :second_team_id, :second_user_id)
    end
end
