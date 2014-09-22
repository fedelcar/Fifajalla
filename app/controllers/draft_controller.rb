class DraftController < ApplicationController
  def index
  	
  	
  	@drafts=Draft.all.order(created_at: :desc)
  	
    @users=User.all
  	@players=Player.all
  	
  end

  def givePicks
    for i in 1..54
      
      @pick = Pick.new
      @pick.user_id=9
      @pick.number=458+i
      @pick.draft_id=7
      @pick.player_id=62302
      @pick.save
    end
    
    redirect_to '/draft/7'
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
      @link='/players?filter=all'
      
      if (@player.user_id==1 or current_user.id==10) #and (@player.league!='Primera Division')
          @np = next_pick.user_id
          @initial=(Pick.find_by number: (next_pick.number-1)).updated_at

          @team=Team.where("user_id=?",next_pick.user_id).last.id
          @user=User.find(next_pick.user_id)
      		@player.user_id=next_pick.user_id
      		@player.team_id=@team
      		@player.save
      		@pick=Pick.find(next_pick.id)
      		@pick.player_id=@player.id
      		@pick.save
          
          @final = @pick.updated_at

          if @initial.hour >=10 and @final.hour >=10 and @initial.day == @final.day
              @minutesForPick = @final.to_i/60 - @initial.to_i/60  
          end

          if @initial.hour >=10 and @final.hour >=10 and @initial.day != @final.day
              @minutesForPick = (24 - @initial.hour)*60 + (60-@initial.min) + (@final.hour-10*60) + @final.min
          end

          if @initial.hour <10 and @final.hour < 10
            @minutesForPick=0
          end

          if @initial.hour<10 and @final.hour>=10
            @minutesForPick= (@final.hour-10*60) + @final.min
          end

          if @initial.hour >=10 and @final.hour<10
            @minutesForPick = (24 - @initial.hour)*60 + (60-@initial.min)
          end


          @user.minutes = @user.minutes - @minutesForPick
          @user.save

          if next_pick != nil and next_pick.user_id!=10
            #UserMailer.next_pick(User.find(next_pick.user_id)).deliver
          end

          if next_pick != nil
             #si al proximo se le agotó el tiempo drafteo solo
            @nextUser = User.find(next_pick.user_id)
            if @nextUser.minutes <= 0
              #busco al libre de mayor ovr
              @playerToDraft = Player.where("user_id=1")  
              @link = "/draft/draftPlayer?id="+ @playerToDraft.first.id.to_s
            end
          end

      end
      redirect_to @link
  end
end
