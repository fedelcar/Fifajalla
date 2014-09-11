class DraftController < ApplicationController
  def index
  	
  	
  	@drafts=Draft.all.order(created_at: :desc)
  	
    @users=User.all
  	@players=Player.all
  	
  end

  def givePicks
    for i in 1..108
      
      @pick = Pick.new
      @pick.user_id=10
      @pick.number=291+i
      @pick.draft_id=6
      @pick.player_id=62302
      @pick.save
    end
    
    redirect_to '/draft/6'
  end

  def show
    @picks=Pick.where("draft_id=?",params[:id]).order(number: :asc)
    @draft=Draft.find(params[:id])
    @numberOfUsers=@draft.users
    @users=User.all
    @players=Player.all
    
  end

  def released
    @released = Release.all.order(created_at: :desc)
  end

  def draftPlayer
  		@player=Player.find(params[:id])
      if (@player.user_id==1 or current_user.id==10 or @player.team_id==47 or @player.team_id==48) and (@player.league=='Primera Division')
          @np = next_pick.user_id
          @team=Team.where("user_id=?",next_pick.user_id).last.id
      		@player.user_id=next_pick.user_id
      		@player.team_id=@team
      		@player.save
      		@pick=Pick.find(next_pick.id)
      		@pick.player_id=@player.id
      		@pick.save
      end

      if next_pick != nil and next_pick.user_id!=10
        UserMailer.next_pick(User.find(next_pick.user_id)).deliver
      end

  		redirect_to team_path(@team)

  end
end
