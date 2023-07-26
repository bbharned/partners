class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


helper_method :current_user, :logged_in?, :has_events

	  def current_user
	    @current_user ||= User.find(session[:user_id]) if session[:user_id]
	  end


	  def logged_in?
	    !!current_user
	  end


	  def require_user
	    if !logged_in?
	        flash[:danger] = "You must be logged in to perform that action."
	        redirect_to login_path
	    end
	  end

	  def has_events
	  	@admin_events = Event.where(viewer: current_user.email)
	  end


end
