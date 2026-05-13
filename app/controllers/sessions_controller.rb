class SessionsController < ApplicationController
  def impersonate
    session[:user_id] = params[:user_id].to_i
    redirect_back(fallback_location: root_path)
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
