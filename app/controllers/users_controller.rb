class UsersController < ApplicationController

	def index
		@users = User.where("id>1 and id <100")
		@userMatches = Array.new
		@pg = Array.new
		@pe = Array.new
		@pp = Array.new
		@pts = Array.new
		@pj = Array.new
		@gf = Array.new
		@gc = Array.new
		@dg = Array.new
		@eff = Array.new
		@amarillas = Array.new
		@rojas = Array.new
		@list = Array.new
		@categories = Array.new
		@categories = ["ID","Usuario","ELO","PJ","PG","PE","PP","Pts","Eff","GF","GC","DG","Amarillas","Rojas"]

		@users.each do |user|
			@userMatches = Match.where('local_user_id=? or away_user_id=?',user.id,user.id)
			@pg = @userMatches.where('(local_user_id=? and local_goals > away_goals) or (away_user_id=? and away_goals > local_goals)',user.id,user.id).count
			@pe = @userMatches.where('local_goals=away_goals').count
			@pp = @userMatches.where('(local_user_id=? and local_goals < away_goals) or (away_user_id=? and away_goals < local_goals)',user.id,user.id).count
			@pts = @pg*3+@pe
			@pj = @pg+@pe+@pp
			@gf = @userMatches.where('local_user_id=?',user.id).sum(:local_goals)
			@gf += @userMatches.where('away_user_id=?',user.id).sum(:away_goals)
			@gc = @userMatches.where('local_user_id=?',user.id).sum(:away_goals)
			@gc += @userMatches.where('away_user_id=?',user.id).sum(:local_goals)
			@dg=@gf-@gc
			if @pj >0
				@eff=@pts.to_f/(3*@pj)*100
			else
				@eff=0
			end
			@amarillas= Event.where("user_id=? and event_type_id=12",user.id).count
			@rojas= Event.where("user_id=? and event_type_id=14",user.id).count

			@teamArray = [user.id,user.display_name,user.elo,@pj,@pg,@pe,@pp,@pts,@eff,@gf,@gc,@dg,@amarillas,@rojas]

			@list.push(@teamArray)
		end

		@users = sortList(@categories,params[:sort],@list)
	end


	def show
		@user = User.find_by id: params[:id]
		@userMatches = Match.where('local_user_id=? or away_user_id=?',params[:id],params[:id])
		@pg = @userMatches.where('(local_user_id=? and local_goals > away_goals) or (away_user_id=? and away_goals > local_goals)',params[:id],params[:id]).count
		@pe = @userMatches.where('local_goals=away_goals').count
		@pp = @userMatches.where('(local_user_id=? and local_goals < away_goals) or (away_user_id=? and away_goals < local_goals)',params[:id],params[:id]).count
		@pts = @pg*3+@pe
		@pj = @pg+@pe+@pp
		@gf = @userMatches.where('local_user_id=?',params[:id]).sum(:local_goals)
		@gf += @userMatches.where('away_user_id=?',params[:id]).sum(:away_goals)
		@gc = @userMatches.where('local_user_id=?',params[:id]).sum(:away_goals)
		@gc += @userMatches.where('away_user_id=?',params[:id]).sum(:local_goals)
		@dg=@gf-@gc
		@gfpp=@gf.to_f/@pj
		@gcpp=@gc.to_f/@pj
		@dgpp=@gfpp-@gcpp


		if @pj >0
			@efectividad=@pts.to_f/(3*@pj)
		else
			@efectividad=0
		end
		@teams = Team.where("user_id=?", params[:id])

	end




	def update
		@user = User.find(current_user.id)

		if params[:display_name] != ""
			@user.display_name = params[:display_name]
		end
		if params[:email] !=""
			@user.email = params[:email]
		end

		@user.save
		redirect_to users_path


	end


	def create
		@user = User.new(user_params)
 		if User.where(name:@user.name).exists? or User.where(email:@user.email).exists?

 		else
 			if @user.display_name == ""
 				@user.display_name = @user.name.split(" ").first
		 		@user.elo=1400
		 		@user.save
 			end


 			@user.save
 			UserMailer.welcome_email(@user).deliver

 		end

		redirect_to 'teams/new'
	end

	def new
		@user = User.new
		@user.name = params[:user][:name]
		@user.display_name = @user.name
		@user.elo = params[:user][:elo]
		@user.isAdmin=false
		@user.save
		redirect_to '/users/'+@user.id.to_s
	end

	def destroy
		User.delete(params[:id])
		redirect_to '/users?sort=ELO'
	end

	private
		def user_params
			params.require(:user).permit(:name, :id, :email, :password_confirmation, :display_name, :isAdmin)
		end

		def sort_column
			params[:sort] || "eff"
		end

		def sort_direction
			params[:direction] || "desc"
		end

end
