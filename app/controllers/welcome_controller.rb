class WelcomeController < ApplicationController
  def index

  	@numberOfUsers=User.count-2
  	
  	@users=User.all
  	@players=Player.all

  	@matches = Match.order(date: :desc).take(5)
  	
  	@teams = Team.all

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
