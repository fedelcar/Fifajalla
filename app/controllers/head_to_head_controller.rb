class HeadToHeadController < ApplicationController
  def index
    @users=User.where("id>1")
    @groupedUsers=Array.new
    @users.each do |user|
      @groupedUsers.push(user.display_name)
    end
  end

  def show
    @user1=User.find_by display_name:(params[:head_to_head][:user1])
    @user2=User.find_by display_name:(params[:head_to_head][:user2])
    if @user1.id == @user2.id
      redirect_to '/head_to_head/index'
    end

    @matches = Match.where('(local_user_id=? and away_user_id=?) or (local_user_id=? and away_user_id=?)',@user1.id,@user2.id,@user2.id,@user1.id).order(updated_at: :desc)
    @pg1 = @matches.where('(local_user_id=? and local_goals>away_goals)or(away_user_id=? and away_goals>local_goals)',@user1.id,@user1.id).count
    @pp2 = @pg1
    @pe = @matches.where('local_goals=away_goals').count
    @pp1 = @matches.where('(local_user_id=? and local_goals<away_goals)or(away_user_id=? and away_goals<local_goals)',@user1.id,@user1.id).count
    @pg2=@pp1

    @gf1= @matches.where('(local_user_id=?)',@user1.id).sum("local_goals")
    @gf1+=@matches.where('(away_user_id=?)',@user1.id).sum("away_goals")
    @gc2=@gf1

    @gf2= @matches.where('(local_user_id=?)',@user2.id).sum("local_goals")
    @gf2+=@matches.where('(away_user_id=?)',@user2.id).sum("away_goals")
    @gc1=@gf2


    @goles = Event.where('((user_id=?)or(user_id=?)) and goal_type_id <> 2 and event_type_id = 2',@user1.id,@user2.id)
    @asistencias = Event.where('((user_id=?)or(user_id=?)) and event_type_id = 3',@user1.id,@user2.id)
    @poms = Event.where('((user_id=?)or(user_id=?)) and event_type_id = 9',@user1.id,@user2.id)

    @goleadores = Array.new
    @asistidores = Array.new
    @pomPlayers = Array.new

    @ids = Array.new
    @matches.each do |match|
      @ids.push(match.id)
    end

    @goles.each do |gol|
      if @ids.include?(gol.match_id)
        @player = Player.find(gol.player_id)
        @toAdd=[@player.first_name+' '+@player.last_name,@goles.where('player_id=? and match_id in (?)',@player.id,@ids).count,@player.id]
        if ! @goleadores.include?(@toAdd)
          @goleadores.push(@toAdd)
        end
      end
      @goleadores = sortList([1,2],2,@goleadores)
    end

    @asistencias.each do |asistencia|
      if @ids.include?(asistencia.match_id)
        @player = Player.find(asistencia.player_id)
        @toAdd=[@player.first_name+' '+@player.last_name,@asistencias.where('player_id=? and match_id in (?)',@player.id,@ids).count,@player.id]
        if ! @asistidores.include?(@toAdd)
          @asistidores.push(@toAdd)
        end
      end
      @asistidores = sortList([1,2],2,@asistidores)
    end

    @poms.each do |pom|
      if @ids.include?(pom.match_id)
        @player = Player.find(pom.player_id)
        @toAdd=[@player.first_name+' '+@player.last_name,@poms.where('player_id=? and match_id in (?)',@player.id,@ids).count,@player.id]
        if ! @pomPlayers.include?(@toAdd)
          @pomPlayers.push(@toAdd)
        end
      end
      @pomPlayers = sortList([1,2],2,@pomPlayers)
    end


  end
end
