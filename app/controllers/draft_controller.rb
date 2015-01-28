class DraftController < ApplicationController
  def index


  	@drafts=Draft.all.order(created_at: :desc)

    @users=User.all
  	@players=Player.all

  end


  def givePicks
    for i in 3..9
      @pick = Pick.new
      @pick.user_id=3
      @pick.number= (i-1) *26 + 2
      @pick.id=@pick.number
      @pick.draft_id=1
      @pick.player_id=1
      @pick.save

      @pick2 = Pick.new
      @pick2.user_id=3
      @pick2.number= i*26  - 1
      @pick2.id=@pick2.number
      @pick2.draft_id=1
      @pick2.player_id=1
      @pick2.save
    end

    redirect_to '/draft/1'
  end

  def removeWanted
    @toDelete = WantedPlayer.where('user_id=? and player_id=?',current_user.id, params[:player_id]).first
    @toDelete.destroy
    redirect_to '/draft/wanted'
  end

 def addWanted
    @toDelete = WantedPlayer.where('user_id=? and player_id=?',current_user.id, params[:player_id]).first
    if @toDelete == nil
      @toAdd= WantedPlayer.new
      @toAdd.user_id = current_user.id
      @toAdd.player_id = params[:player_id]
      @toAdd.save
    end
    redirect_to :back
  end

  def show
    @picks=Pick.where("draft_id=?",params[:id]).order(number: :asc)
    @draft=Draft.find(params[:id])
    @numberOfUsers=@draft.users
    @users=User.all
    @players=Player.all

  end

  def wanted
    @wantedPlayers = WantedPlayer.where('user_id=?',current_user.id)
    
    @list = Array.new
    @categories = Array.new
    @categories = ["ID","Jugador","OVR","Pos"]
    @wantedPlayers.each do |p|
      @player = Player.find(p.player_id)
      @list.push([@player.id,@player.first_name + " " + @player.last_name,@player.overall,@player.primary_position])
    end
    @wanted = sortList(@categories,params[:sort],@list)


  end

  def released
    @released = Release.all.order(created_at: :desc)
  end

  def draftPlayer
  		@player=Player.find(params[:id])
      @link='/players?filter1=all&filter2=undrafted&filter3=all&filter4=Argentina'

      if (@player.user_id==1 or current_user.id==10) #and (@player.league!='Primera Division')
          @np = next_pick.user_id
          @initial=(Pick.find_by number: (next_pick.number-1)).updated_at.localtime


          @team=Team.where("user_id=?",next_pick.user_id).last.id
          @user=User.find(next_pick.user_id)
      		@player.user_id=next_pick.user_id
      		@player.team_id=@team
      		@player.save
      		@pick=Pick.find(next_pick.id)
      		@pick.player_id=@player.id
      		@pick.save
          @wanted = WantedPlayer.where('player_id=?',@player.id)
          @wanted.each do |wanted|
            wanted.delete
          end
          @final = @pick.updated_at.localtime

          if @initial.hour >=10 and @final.hour >=10 and @initial.day == @final.day
              @minutesForPick = @final.to_i/60 - @initial.to_i/60
          end

          if @initial.hour >=10 and @final.hour >=10 and @initial.day != @final.day
              @minutesForPick = (23 - @initial.hour)*60 + (60-@initial.min) + ((@final.hour-10)*60) + @final.min
          end

          if @initial.hour <10 and @final.hour < 10 and @initial.day == @final.day
            @minutesForPick=0
          end

          if @initial.hour<10 and @final.hour>=10 and @initial.day == @final.day
            @minutesForPick= ((@final.hour-10)*60) + @final.min
          end

           if @initial.hour<10 and @final.hour>=10 and @initial.day != @final.day
            @minutesForPick= 700
          end

          if @initial.hour >=10 and @final.hour<10 and @initial.day != @final.day
            @minutesForPick = (23 - @initial.hour)*60 + (60-@initial.min)
          end

          @user.minutes = @user.minutes - @minutesForPick
          @user.save

          if next_pick != nil and next_pick.user_id!=10
            #UserMailer.next_pick(User.find(next_pick.user_id)).deliver
          end

          if next_pick != nil and 1==0

             #si al proximo se le agotó el tiempo drafteo solo
            @nextUser = User.find(next_pick.user_id)


            if @nextUser.minutes <= 0 or @nextUser.id ==4 or @nextUser.id ==5 
              #busco al libre de mayor ovr
              @playerToDraft = Player.where("user_id=1 and id >1")
              @link = "/draft/draftPlayer?id="+ @playerToDraft.first.id.to_s
            end

            if @nextUser.id ==3
              #busco al libre de menor ovr
              @playerToDraft = Player.where("user_id=1 and id >1")
              @link = "/draft/draftPlayer?id="+ @playerToDraft.last.id.to_s
            end

            @wantedNow = WantedPlayer.where('user_id=?',@nextUser.id)

            if @wantedNow.first != nil
              @link = "/draft/draftPlayer?id="+ @wantedNow.first.player_id.to_s
            end


          end

      end

  
      redirect_to @link
  end
end
