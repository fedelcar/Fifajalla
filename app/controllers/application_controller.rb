class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  #protect_from_forgery with: :null_session
  helper_method :current_user
  helper_method :next_pick

  def next_pick
  	@next_pick = Pick.where("player_id=62302").first
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

end
