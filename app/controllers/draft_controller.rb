class DraftController < ApplicationController
  def index
  	@picks=Pick.all
  	@numberOfUsers=User.count-1
  	
  	@users=User.all
  	@players=Player.all
  	@currentPick=1
  end

  def draftPlayer
  		@player=Player.find(params[:id])
      if @player.user_id=1
    		@team=Team.find_by user_id: next_pick.user_id
    		@player.user_id=next_pick.user_id
    		@player.team_id=@team.id
    		@player.save
    		@pick=Pick.find(next_pick.id)
    		@pick.player_id=@player.id
    		@pick.save
      end
  		redirect_to '/draft'

  end
end
