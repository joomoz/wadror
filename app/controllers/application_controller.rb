class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Makes current_user visible for views
  helper_method :current_user

  def current_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice:'You have to be signed in first!' if not current_user
  end

  def only_admins
    redirect_to breweries_path, notice:'Only admins can do that!' if not current_user.admin
  end

end
