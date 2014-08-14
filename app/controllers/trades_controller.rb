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

  def addToTradeBlock
  	
  end


  def index
  	@trades=Trade.all
  	@players = Player.all
  	@teams = Team.all
  	@users = User.all
  end

	def create
		@trade = Trade.new
    
    @approvalA = Approval.new
    @approvalA.trade_id=@trade.id
    @approvalA.user_id=params[:user_id_A]
    @approvalA.approved=false
    @approvalA.save

    @approvalB = Approval.new
    @approvalB.trade_id=@trade.id
    @approvalB.user_id=params[:user_id_B]
    @approvalB.approved=false
    @approvalB.save

    if params[:player_id_A1] != 62302
      @pm=Player_movement.new
      @pm.player_id=params[:player_id_A1]
      @pm.first_user_id=params[:user_id_A]
      @pm.second_user_id=params[:user_id_B]
      @pm.first_team_id=(Team.find_by user_id: params[:user_id_A]).id
      @pm.second_team_id=(Team.find_by user_id: params[:user_id_B]).id
      @pm.save
    end 

    if params[:player_id_A2] != 62302
      @pm=Player_movement.new
      @pm.player_id=params[:player_id_A2]
      @pm.first_user_id=params[:user_id_A]
      @pm.second_user_id=params[:user_id_B]
      @pm.first_team_id=(Team.find_by user_id: params[:user_id_A]).id
      @pm.second_team_id=(Team.find_by user_id: params[:user_id_B]).id
      @pm.save
    end

    if params[:player_id_A3] != 62302
      @pm=Player_movement.new
      @pm.player_id=params[:player_id_A3]
      @pm.first_user_id=params[:user_id_A]
      @pm.second_user_id=params[:user_id_B]
      @pm.first_team_id=(Team.find_by user_id: params[:user_id_A]).id
      @pm.second_team_id=(Team.find_by user_id: params[:user_id_B]).id
      @pm.save
    end

    if params[:player_id_A4] != 62302
      @pm=Player_movement.new
      @pm.player_id=params[:player_id_A4]
      @pm.first_user_id=params[:user_id_A]
      @pm.second_user_id=params[:user_id_B]
      @pm.first_team_id=(Team.find_by user_id: params[:user_id_A]).id
      @pm.second_team_id=(Team.find_by user_id: params[:user_id_B]).id
      @pm.save
    end

    if params[:player_id_A5] != 62302
      @pm=Player_movement.new
      @pm.player_id=params[:player_id_A5]
      @pm.first_user_id=params[:user_id_A]
      @pm.second_user_id=params[:user_id_B]
      @pm.first_team_id=(Team.find_by user_id: params[:user_id_A]).id
      @pm.second_team_id=(Team.find_by user_id: params[:user_id_B]).id
      @pm.save
    end

    if params[:player_id_B1] != 62302
      @pm=Player_movement.new
      @pm.player_id=params[:player_id_B1]
      @pm.first_user_id=params[:user_id_B]
      @pm.second_user_id=params[:user_id_A]
      @pm.first_team_id=(Team.find_by user_id: params[:user_id_B]).id
      @pm.second_team_id=(Team.find_by user_id: params[:user_id_A]).id
      @pm.save
    end 

    if params[:player_id_B2] != 62302
      @pm=Player_movement.new
      @pm.player_id=params[:player_id_B2]
      @pm.first_user_id=params[:user_id_B]
      @pm.second_user_id=params[:user_id_A]
      @pm.first_team_id=(Team.find_by user_id: params[:user_id_B]).id
      @pm.second_team_id=(Team.find_by user_id: params[:user_id_A]).id
      @pm.save
    end

    if params[:player_id_B3] != 62302
      @pm=Player_movement.new
      @pm.player_id=params[:player_id_B3]
      @pm.first_user_id=params[:user_id_B]
      @pm.second_user_id=params[:user_id_A]
      @pm.first_team_id=(Team.find_by user_id: params[:user_id_B]).id
      @pm.second_team_id=(Team.find_by user_id: params[:user_id_A]).id
      @pm.save
    end

    if params[:player_id_B4] != 62302
      @pm=Player_movement.new
      @pm.player_id=params[:player_id_B4]
      @pm.first_user_id=params[:user_id_B]
      @pm.second_user_id=params[:user_id_A]
      @pm.first_team_id=(Team.find_by user_id: params[:user_id_B]).id
      @pm.second_team_id=(Team.find_by user_id: params[:user_id_A]).id
      @pm.save
    end

    if params[:player_id_B5] != 62302
      @pm=Player_movement.new
      @pm.player_id=params[:player_id_B5]
      @pm.first_user_id=params[:user_id_B]
      @pm.second_user_id=params[:user_id_A]
      @pm.first_team_id=(Team.find_by user_id: params[:user_id_B]).id
      @pm.second_team_id=(Team.find_by user_id: params[:user_id_A]).id
      @pm.save
    end



		@trade.save
		redirect_to trades_path
	end

	private
		def trade_params
			params.require(:trade).permit(:player_id, :first_team_id, :first_user_id, :second_team_id, :second_user_id)
		end
end
