class DraftController < ApplicationController
  def index
  	
  	
  	@drafts=Draft.all.order(created_at: :desc)
  	
    @users=User.all
  	@players=Player.all
  	
  end

  def show
    @picks=Pick.where("draft_id=?",params[:id])
    @draft=Draft.find(params[:id])
    @numberOfUsers=@draft.users
    @users=User.all
    @players=Player.all
    @currentPick=1
  end

  def released
    @released = Release.all.order(created_at: :desc)
  end

  def draftPlayer
  		@player=Player.find(params[:id])
      if @player.user_id==1 or current_user.id==10 or @player.team_id==47 or @player.team_id==48
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
