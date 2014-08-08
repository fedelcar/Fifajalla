class DraftController < ApplicationController
  def index
  	@picks=Pick.all
  	@numberOfUsers=User.count-1
  	
  	@users=User.all
  	@players=Player.all
  	@currentPick=1
  end
end
