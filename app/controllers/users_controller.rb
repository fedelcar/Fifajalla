class UsersController < ApplicationController

	def index

		@users = User.where("id>1 and id <100").order(sort_column + ' ' + sort_direction)
<<<<<<< Updated upstream
=======
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


>>>>>>> Stashed changes
		@users.each do |user|
			@userMatches[user.id] = Match.where('local_user_id=? or away_user_id=?',user.id,user.id)
			@pg[user.id] = @userMatches[user.id].where('(local_user_id=? and local_goals > away_goals) or (away_user_id=? and away_goals > local_goals)',user.id,user.id).count
			@pe[user.id] = @userMatches[user.id].where('local_goals=away_goals').count
			@pp[user.id] = @userMatches[user.id].where('(local_user_id=? and local_goals < away_goals) or (away_user_id=? and away_goals < local_goals)',user.id,user.id).count
			@pts[user.id] = @pg[user.id]*3+@pe[user.id]
			@pj[user.id] = @pg[user.id]+@pe[user.id]+@pp[user.id]
			@gf[user.id] = @userMatches[user.id].where('local_user_id=?',user.id).sum(:local_goals)
			@gf[user.id] += @userMatches[user.id].where('away_user_id=?',user.id).sum(:away_goals)
			@gc[user.id] = @userMatches[user.id].where('local_user_id=?',user.id).sum(:away_goals)
			@gc[user.id] += @userMatches[user.id].where('away_user_id=?',user.id).sum(:local_goals)
			@dg[user.id]=@gf[user.id]-@gc[user.id]
			if @pj[user.id] >0
				@eff[user.id]=@pts[user.id].to_f/(3*@pj[user.id])
			else
				@eff[user.id]=0
			end
		end

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
 				@user.gf=0
		 		@user.ga=0
		 		@user.wins=0
		 		@user.loses=0
		 		@user.draws=0
		 		@user.dg=0
		 		@user.pts=0
<<<<<<< Updated upstream
		 		@user.eff=0	
=======
		 		@user.eff=0
>>>>>>> Stashed changes
		 		@user.save
 			end


 			@user.save
 			UserMailer.welcome_email(@user).deliver

 		end

		redirect_to 'teams/new'
	end

	def destroy
		User.destroy(params[:id])
		@users = User.all

		render 'users/index'
	end

	private
		def user_params
			params.require(:user).permit(:name, :id, :password, :email, :password_confirmation, :display_name)
		end

		def sort_column
			params[:sort] || "eff"
		end

		def sort_direction
			params[:direction] || "desc"
		end

end
