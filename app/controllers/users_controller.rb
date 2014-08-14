class UsersController < ApplicationController

	def index

		@users = User.where("id>1").order(sort_column + ' ' + sort_direction)
		@users.each do |user|
			user.eff=user.pts.to_f/((user.wins+user.draws+user.loses)*3)
			user.save
		end

	end

	def show
		@user = User.find_by id: params[:id]
		if @user
			@pj = @user.wins+@user.draws+@user.loses
			@pts = @user.wins*3+@user.draws
			@efectividad = @pts.to_f/(3*@pj)
			@gfpp = @user.gf.to_f/@pj.to_f
			@gapp = @user.ga.to_f/@pj.to_f
			@dgpp = @gfpp.to_f-@gapp.to_f
			@teams = Team.where("user_id=?", params[:id])
		else
			@pj = 0
			@pts = 0
			@efectividad = 0
			@gfpp = 0
			@gapp = 0
			@dgpp = 0
			@teams = ""
		end

	end




	def update
	  
		@user = User.find(current_user.id)
		
		@user.display_name = params[:display_name]
		@user.email = params[:email]

		@user.save
		redirect_to users_path
   

	end


	def create
		@user = User.new(user_params)
 		if User.where(name:@user.name).exists? or User.where(email:@user.email).exists?

 		else
 			if @user.display_name=""
 				@user.display_name = @user.name.split(" ").first
 			end
	 		@user.gf=0
	 		@user.ga=0
	 		@user.wins=0
	 		@user.loses=0
	 		@user.draws=0
	 		@user.dg=0
	 		@user.pts=0
	 		@user.eff=0	
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
			params.require(:user).permit(:name, :id, :password, :email, :password_confirmation, :display_name)
		end

		def sort_column
			params[:sort] || "wins"
		end
		  
		def sort_direction
			params[:direction] || "desc"
		end

end
