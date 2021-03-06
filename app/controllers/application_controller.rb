class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def log_in!(user)
    user.reset_session_token!
    session[:token] = user.session_token
    if user.email == "guest@guest.com"
      user.set_up_data
    end
  end

  def log_out!
    current_user.reset_session_token!
    session[:token] = nil
  end

  def current_user
    User.find_by_session_token(session[:token])
  end

  def logged_in?
    !!current_user
  end

  def require_signed_in!
    redirect_to new_user_url unless logged_in?
  end

end
