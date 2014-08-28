class WelcomeController < ApplicationController
  def index

  	@numberOfUsers=User.count-1
  	
  	@users=User.all
  	@players=Player.all

  	@matches = Match.where("finished='t'").order(updated_at: :desc).take(5)
  	
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
  end
end
