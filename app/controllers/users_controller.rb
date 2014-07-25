class UsersController < ApplicationController

	def index
		@users = User.all
	end

	def show
		@user = User.find_by name: params[:id]
		@stats = Stat.find(@user.id)
		@pj = @stats.wins+@stats.draws+@stats.loses
		@pts = @stats.wins*3+@stats.draws
		@efectividad = @pts.to_f/(3*@pj)
		@gfpp = @stats.gf.to_f/@pj.to_f
		@gapp = @stats.ga.to_f/@pj.to_f
		@dgpp = @gfpp.to_f-@gapp.to_f
		@teams = Team.where("user_id=?", @user.id)


	end

	def create
		@user = User.new(user_params)
 		if User.where(name:@user.name).exists? or User.where(email:@user.email).exists?
 			
 		else
 			@user.save
 			UserMailer.welcome_email(@user).deliver

 		end
		
		redirect_to users_path
	end

	def destroy
		User.destroy(params[:id])
		@users = User.all
		
		render 'users/index'
	end

	private
	
		def user_params
			params.require(:user).permit(:name, :id, :password, :email, :password_confirmation)
		end

end
