class HeadToHeadController < ApplicationController

  def show
    @user1=User.find_by display_name:(params[:user1])
    @user2=User.find_by display_name:(params[:user2])
    if @user1.id == @user2.id
      redirect_to '/head_to_head/table'
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
    @maxDifUser1 = (-100)
    @maxMatchUser1 = @matches.take(1)
    @maxDifUser2 = (-100)
    @maxMatchUser2 = @matches.take(1)
    @matches.each do |match|
      @ids.push(match.id)
      if match.local_user_id==@user1.id #el user 1 es local
        @dif = match.local_goals - match.away_goals
        if @dif > @maxDifUser1
          @maxDifUser1 = @dif
          @maxMatchUser1 = match
        else
          if @dif == @maxDifUser1 && (@matches.find(match.id).local_goals+@matches.find(match.id).away_goals > @matches.find(@maxMatchUser1.id).local_goals+@matches.find(@maxMatchUser1.id).away_goals)
            @maxDifUser1 = @dif
            @maxMatchUser1 = match
          end
        end

        #idem para user2
        @dif2 = match.away_goals - match.local_goals
        if @dif2 > @maxDifUser2
          @maxDifUser2 = @dif2
          @maxMatchUser2 = match
        else
          if @dif2 == @maxDifUser2 && (@matches.find(match.id).local_goals+@matches.find(match.id).away_goals > @matches.find(@maxMatchUser2.id).local_goals+@matches.find(@maxMatchUser2.id).away_goals)
            @maxDifUser2 = @dif2
            @maxMatchUser2 = match
          end
        end

      else #el user 1 es visitante
        
        @dif = match.away_goals - match.local_goals
        if @dif > @maxDifUser1
          @maxDifUser1 = @dif
          @maxMatchUser1 = match
        else
          if @dif == @maxDifUser1 && (@matches.find(match.id).local_goals+@matches.find(match.id).away_goals > @matches.find(@maxMatchUser1.id).local_goals+@matches.find(@maxMatchUser1.id).away_goals)
             @maxDifUser1 = @dif
            @maxMatchUser1 = match
          end
        end

        #idem para user 2
        @dif2 = match.local_goals - match.away_goals
        if @dif2 > @maxDifUser2
          @maxDifUser2 = @dif2
          @maxMatchUser2 = match
        else
          if @dif2 == @maxDifUser2 && (@matches.find(match.id).local_goals+@matches.find(match.id).away_goals > @matches.find(@maxMatchUser2.id).local_goals+@matches.find(@maxMatchUser2.id).away_goals)
            @maxDifUser2 = @dif2
            @maxMatchUser2 = match
          end
        end
      end
    end

    #busco goles y equipos de mayor goleada user 1
    if @maxMatchUser1.local_team_id <= 500
      @equipo1 = Team.find(@maxMatchUser1.local_team_id).name
    else
      @equipo1 = Realteam.find(@maxMatchUser1.local_team_id).name
    end
    if @maxMatchUser1.away_team_id <= 500
      @equipo2 = Team.find(@maxMatchUser1.away_team_id).name
    else
      @equipo2 = Realteam.find(@maxMatchUser1.away_team_id).name
    end
    @goleada1 = @equipo1 + " " + @matches.find(@maxMatchUser1.id).local_goals.to_s + " - "+@matches.find(@maxMatchUser1.id).away_goals.to_s + " " + @equipo2
    
    #busco goles y equipos de mayor goleada user 2
    if @maxMatchUser2.local_team_id <= 500
      @equipo1 = Team.find(@maxMatchUser2.local_team_id).name
    else
      @equipo1 = Realteam.find(@maxMatchUser2.local_team_id).name
    end
    if @maxMatchUser2.away_team_id <= 500
      @equipo2 = Team.find(@maxMatchUser2.away_team_id).name
    else
      @equipo2 = Realteam.find(@maxMatchUser2.away_team_id).name
    end
    @goleada2 = @equipo1 + " " + @matches.find(@maxMatchUser2.id).local_goals.to_s + " - "+@matches.find(@maxMatchUser2.id).away_goals.to_s + " " + @equipo2
    

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

  def table
    @users = User.where("id>1").order(id: :asc)
    @userIDs = Array.new
    @users.each do |u|
      @userIDs.push(u.id)
    end

    @lastUser = @users.last.id
    @result = Array.new(@lastUser+1){ Array.new(@lastUser+1)}
    

    for i in 2..@lastUser
      for x in i..@lastUser
          if @userIDs.include?(x) && @userIDs.include?(i)
            if i == x
              @result[i][x]="-"
            else
              @user1=User.find(i)
              @user2=User.find(x)

              @matches = Match.where('(local_user_id=? and away_user_id=?) or (local_user_id=? and away_user_id=?)',@user1.id,@user2.id,@user2.id,@user1.id)
              @pg1 = @matches.where('(local_user_id=? and local_goals>away_goals)or(away_user_id=? and away_goals>local_goals)',@user1.id,@user1.id).count
              @pp2 = @pg1
              @pp1 = @matches.where('(local_user_id=? and local_goals<away_goals)or(away_user_id=? and away_goals<local_goals)',@user1.id,@user1.id).count
              @pg2 = @pp1
              @result[i][x] = (@pg1.to_s) + "-" + (@pg2.to_s)
              @result[x][i] = (@pg2.to_s) + "-" + (@pg1.to_s)
            end
          end     
      end
    end
  end
end
