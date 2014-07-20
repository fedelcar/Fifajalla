class UsersController < ApplicationController

	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end

	def create
		@user = User.new(user_params)
 
		@user.save
		redirect_to users_path
	end

	def destroy
		User.destroy(params[:id])
		@users = User.all
		
		render 'users/index'
	end

	private
	
		def user_params
			params.require(:user).permit(:name, :id)
		end

end
