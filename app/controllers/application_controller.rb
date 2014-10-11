class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  #protect_from_forgery with: :null_session
  helper_method :current_user
  helper_method :next_pick



  def next_pick
  	if Pick.where("player_id=1").count>0
      @next_pick = Pick.where("player_id=1").first
    else

    end
  end

  def sortList(categories, sorter, list)
    @sortCol = categories.index(sorter)
    if @sortCol==nil
      @sortCol =0
    end
    return list.sort! { |b,a| a[@sortCol] <=> b[@sortCol] }
  end

  def current_user
    if User.exists?(session[:user_id])
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end

end
