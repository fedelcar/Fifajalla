class LeagueController < ApplicationController
  def index
    # 2 Germo
    # 3 Piñe
    # 4 Tito 
    # 5 Sene
    # 6 Laucha
    # 7 Facu
    # 8 Ema
    # 9 Rocka
    # 10 Fede
    # 11 Santi
    # 12 Picco
    # 13 Chris

  	@gf=Array.new(50,0)
    @ga=Array.new(50,0)
    @dg=Array.new(50,0)
    @pts=Array.new(50,0)
    @eff=Array.new(50,0)
    @wins=Array.new(50,0)
    @draws=Array.new(50,0)
    @loses=Array.new(50,0)
    @pj=Array.new(50,0)

    @teams = Team.where("user_id<>1 and user_id<> 3 and user_id<>4 and user_id <>5 and user_id <> 7 and user_id <> 11").order(pts: :desc)
  	  @teams.each do |team|
        @matches1= Match.where("local_user_id=? and id>=227 and id <= 254 and finished='t'",team.user_id)
        @matches1.each do |match|
          @gf[team.id]=@gf[team.id]+match.local_goals
          @ga[team.id]=@ga[team.id]+match.away_goals
          @pj[team.id]=@pj[team.id]+1
          if match.local_goals == match.away_goals
            @draws[team.id]=@draws[team.id]+1
          else 
            if match.local_goals > match.away_goals
              @wins[team.id]=@wins[team.id]+1
            else
              @loses[team.id]=@loses[team.id]+1
            end
          end
        end
        @matches2= Match.where("away_user_id=? and id>225 and id <=254 and finished='t'",team.user_id)
        @matches2.each do |match|
          @ga[team.id]=@ga[team.id]+match.local_goals
          @gf[team.id]=@gf[team.id]+match.away_goals
          @pj[team.id]=@pj[team.id]+1
          if match.local_goals == match.away_goals
            @draws[team.id]=@draws[team.id]+1
          else 
            if match.local_goals > match.away_goals
              @loses[team.id]=@loses[team.id]+1
            else
              @wins[team.id]=@wins[team.id]+1
            end
          end
        end

        @dg[team.id]=@gf[team.id]-@ga[team.id]
        @pts[team.id]=@wins[team.id]*3+@draws[team.id]
        @eff[team.id]=@pts[team.id]/((@pj[team.id])*3.0)
        
      end
  end

  private


		def sort_column
			params[:sort] || "pts"
		end
		  
		def sort_direction
			params[:direction] || "desc"
		end
end
