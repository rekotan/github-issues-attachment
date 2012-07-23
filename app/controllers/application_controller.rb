class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def authenticate_user!
    redirect_to root_path unless current_user
  end

  def current_user
    if session[:user_id] && session[:access_token]
      @current_user ||= User.find_by_id_and_access_token(session[:user_id],
                                                         session[:access_token])
    end
  end
  helper_method :current_user

end
