class WelcomeController < ApplicationController
  def index
  	@numberOfUsers=User.count-1

  	@users=User.all
  	@players=Player.all

  	@matches = Match.where("finished='t' and local_team_id<?",101).order(updated_at: :desc).take(5)

  	@teams = Team.all

    if current_user
    	@apps= Trade_Approval.where("user_id=?",current_user.id)
    	@pendingTrade=false
      

      if current_user.elo == nil
        current_user.elo=1400
        current_user.save
      end

    	@apps.each do |app|
    		@trade=Trade.find(app.trade_id)
    		if @trade.status=="Created" and app.approved==false
    			@pendingTrade=true
    		end
    	end
    end



  end

  def download
    send_file('db/mydb.dump', :filename => "mydb.dump")
  end
end
