class LeagueController < ApplicationController
  def index
    @leagues = League.order(created_at: :desc)
  end

  def show
    @league = League.find(params[:id])

    @list = Array.new
    @categories = Array.new
    @categories = ["Equipo","Usuario","PJ","PG","PE","PP","Pts","Eff","GF","GC","DG","Amarillas","Rojas"]


    @matches = Match.where("league_id=?",params[:id])
    @IDS = Array.new
    @matches.each do |match|
      @IDS.push(match.local_team_id)
      @IDS.push(match.away_team_id)
    end
    @teams = Team.where("id in(?)",@IDS)

    @teams.each do |team|
      @pj=0
      @pg=0
      @pe=0
      @pp=0
      @gf=0
      @gc=0
      @dg=0
      @pts=0
      @eff=0

        # Analizo todos los partidos de local de cada equipo
        @matches1 = Match.where("local_team_id = ? and finished = 't' and league_id = ?", team.id, params[:id])
        @matches1.each do |match|
          @gf += match.local_goals
          @gc += match.away_goals
          @pj+=1
          if match.local_goals == match.away_goals
            @pe+=1
          else
            if match.local_goals > match.away_goals
              @pg+=1
            else
              @pp+=1
            end
          end
        end

        # Analizo todos los partidos de visitante de cada equipo
        @matches2 = Match.where("away_team_id = ? and finished = 't' and league_id = ?", team.id, params[:id])
        @matches2.each do |match|
          @gc += match.local_goals
          @gf += match.away_goals
          @pj+=1
          if match.local_goals == match.away_goals
            @pe+=1
          else
            if match.local_goals > match.away_goals
              @pp+=1
            else
              @pg+=1
            end
          end
        end

        @dg= @gf - @gc
        @pts = @pg * 3 + @pe
        @eff = @pts / ((@pj) * 3.0)*100

        @user=Match.where("local_team_id=? and league_id=?",team.id,params[:id]).take

        if @user!=nil
          @user=@user.local_user_id
        else
          @user=Match.where("away_team_id=? and league_id=?",team.id,params[:id]).take.away_user_id
        end
        @user=User.find(@user).display_name
        @teamArray = [team.name,@user,@pj,@pg,@pe,@pp,@pts,@eff,@gf,@gc,@dg,@amarillas,@rojas]

        @list.push(@teamArray)

        @sortedList = Array.new
        @sortedList = sortList(@categories,params[:sort],@list)
       
    end

    if !([7,15].include?(@league.id))
      if @matches.count == Match.where("finished='t' and league_id=?",@league.id).count
        @sortedList = sortList(@categories,"GF",@list)
        @sortedList = sortList(@categories,"DG",@sortedList)
        @sortedList = sortList(@categories,"Pts",@sortedList) 
        @champion = User.find_by display_name: (@sortedList.first[1])
        @league.champion_id = @champion.id
        @league.finished=true
        @league.save
      end
    end

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
