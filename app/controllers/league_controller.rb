class LeagueController < ApplicationController
  def index
    @leagues = League.all.order("id DESC")
  end

  def show
    @league = League.find(params[:id])

    @gf = Array.new(50, 0)
    @ga = Array.new(50, 0)
    @dg = Array.new(50, 0)
    @pts = Array.new(50, 0)
    @eff = Array.new(50, 0)
    @wins = Array.new(50, 0)
    @draws = Array.new(50, 0)
    @loses = Array.new(50, 0)
    @pj = Array.new(50, 0)

    order = Array.new

    @teams = Team.joins("JOIN matches ON (matches.local_team_id = teams.id OR matches.away_team_id = teams.id) AND matches.league_id = " + params[:id]).group(:id)
    @teams.each do |team|
    
        # Analizo todos los partidos de local de cada equipo
        @matches1 = Match.where("local_user_id = ? and finished = 't' and league_id = ?", team.user_id, params[:id])
        @matches1.each do |match|
          @gf[team.id] = @gf[team.id] + match.local_goals
          @ga[team.id] = @ga[team.id] + match.away_goals
          @pj[team.id] = @pj[team.id] + 1
          if match.local_goals == match.away_goals
            @draws[team.id] = @draws[team.id] + 1
          else 
            if match.local_goals > match.away_goals
              @wins[team.id] = @wins[team.id] + 1
            else
              @loses[team.id] = @loses[team.id] + 1
            end
          end
        end

        # Analizo todos los partidos de visitante de cada equipo
        @matches2 = Match.where("away_user_id = ? and finished = 't' and league_id = ?", team.user_id, params[:id])
        @matches2.each do |match|
          @ga[team.id] = @ga[team.id] + match.local_goals
          @gf[team.id] = @gf[team.id] + match.away_goals
          @pj[team.id] = @pj[team.id] + 1
          if match.local_goals == match.away_goals
            @draws[team.id] = @draws[team.id] + 1
          else 
            if match.local_goals > match.away_goals
              @loses[team.id] = @loses[team.id] + 1
            else
              @wins[team.id] = @wins[team.id] + 1
            end
          end
        end

        @dg[team.id] = @gf[team.id] - @ga[team.id]
        @pts[team.id] = @wins[team.id] * 3 + @draws[team.id]
        @eff[team.id] = @pts[team.id] / ((@pj[team.id]) * 3.0)
    end

#    @teams.each do |team|
#      order[team.id] = team
#    end


 #   puts(order)

 #   taken = 1

    # Toma todos los equipos menos el último
  #  for i in order.take(order.count - 1)
   #     # Tomo todos a partir del anterior
    #    for j in order.drop(taken)
     #     if (@pts[i.id] > @pts[j.id]) or (@pts[i.id] == @pts[j.id] and @dg[i.id] > @dg[j.id])
      #      pija = order[j]
       #     order[j] = order[i]
        #    order[i] = order[j]
         # end
        #end
      #taken = taken + 1
    #end


  end

  def new
    @users = User.where("id>1")
    @teams = Team.where("id>1")

    @users_column_a = @users.take(@users.count / 2)
    @users_column_b = @users.drop(@users.count / 2)
  end

  def create

    @teams = Team.where("id>1")

    # Creo un array donde solo almaceno los equipos elegidos
    teams = Array.new
    @teams.all.each do |team|
      # Si está entre los elegidos.
      if params[:league][team.id.to_s] == "1"
        # Lo agrego al array.
        teams.push team.id
      end
    end
    taken = 1

    if (teams.count < 3) or (params[:league][:name] == "")
      redirect_to '/league/new' and return
    end

    @league = League.new
    @league.name = params[:league][:name]
    if teams.count < 6
      @league.importance = 1
    else
      if teams.count < 11
        @league.importance = 2
      else
        @league.importance = 3
      end
    end
    if params[:league][:rounds] == "ida"
      @league.round1_matches = 1
    else
      @league.round1_matches = 2
    end
    @league.finished = false
    @league.save
    
    # Toma todos los equipos menos el último
    for i in teams.take(teams.count - 1)
        # Tomo todos a partir del anterior
        for j in teams.drop(taken)
          create_matches(i, j, @league.id)
          # Si es de ida y vuelta los repito pero invirtiendo localia.
          if params[:league][:rounds] == "idavuelta"
            create_matches(j, i, @league.id)
          end
        end
      # Cuento los equipos que ya tienen todos sus partidos
      taken = taken + 1
    end

    redirect_to '/league'
  end

  def create_matches(home, away, league)
    @match = Match.new
    @match.local_user_id = (Team.find_by id: home).user_id
    @match.away_user_id = (Team.find_by id: away).user_id
    @match.local_team_id = home
    @match.away_team_id = away
    @match.local_goals = 0
    @match.away_goals = 0
    @match.elimination = 0
    @match.golden_goal = 0
    @match.local_penalties = 0
    @match.away_penalties = 0
    @match.finished = false
    @match.date = Time.now.strftime("%Y/%m/%d")
    @match.time = Time.now.strftime("%H:%M:%S")
    @match.league_id = league
    @match.save
  end

  private
		def sort_column
			params[:sort] || "pts"
		end
		  
		def sort_direction
			params[:direction] || "desc"
		end
end
