class WelcomeController < ApplicationController
  def index

  	@numberOfUsers=User.count-1
  	
  	@users=User.all
  	@players=Player.all

  	@matches = Match.order(date: :desc).take(5)
  	
  	@teams = Team.all

 

  end
end
