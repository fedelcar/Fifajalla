class WelcomeController < ApplicationController
  include BloatCheck::WrapRequests
  def index

  	@numberOfUsers=User.count-1

  	@users=User.all
  	@players=Player.all

  	@matches = Match.where("finished='t' and local_team_id<?",101).order(updated_at: :desc).take(5)

  	@teams = Team.all

    if current_user
    	@apps= Trade_Approval.where("user_id=?",current_user.id)
    	@pendingTrade=false
    	@apps.each do |app|
    		@trade=Trade.find(app.trade_id)
    		if @trade.status=="Created" and app.approved==false
    			@pendingTrade=true
    		end
    	end
    end

    @players = Player.where("games_played>4 and user_id>1")
    @playersWithEvents=Array.new
    @players.each do |player|
      if Event.exists?(player_id: player.id)
        @playersWithEvents.push(player)
      end
    end

    @list = Array.new
    @categories = Array.new
    @categories = ["ID","Nombre","Goles", "Asistencias"]
    @playersWithEvents.each do |player|
      @playerEvents=Event.where("player_id=? and team_id<500",player.id)
       @goals=@playerEvents.where("event_type_id=2 and goal_type_id<>2",player.id).count
       @assists=@playerEvents.where("event_type_id=3",player.id).count
      @playerArray = [player.id,player.first_name+ ' ' + player.last_name,@goals,@assists]
      @list.push(@playerArray)
    end

    @players = sortList(@categories,"Goles",@list).take(10)



  end

  def download
    send_file('db/mydb.dump', :filename => "mydb.dump")
  end
end
