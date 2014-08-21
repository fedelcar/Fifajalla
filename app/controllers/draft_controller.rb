class DraftController < ApplicationController
  def index
  	@picks=Pick.all
  	@numberOfUsers=User.count-1
  	
  	@users=User.all
  	@players=Player.all
  	@currentPick=1
  end

  def released
    @released = Release.all
  end

  def draftPlayer
  		@player=Player.find(params[:id])
      if @player.user_id==1 or current_user.id==10
          @np = next_pick.user_id
          @team=Team.where("user_id=?",next_pick.user_id).first.id
      		@player.user_id=next_pick.user_id
      		@player.team_id=@team
      		@player.save
      		@pick=Pick.find(next_pick.id)
      		@pick.player_id=@player.id
      		@pick.save
      end

      if next_pick != nil
        UserMailer.next_pick(User.find(next_pick.user_id)).deliver
      end

  		redirect_to '/draft'

  end
end
