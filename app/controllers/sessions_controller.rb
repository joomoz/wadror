class SessionsController < ApplicationController
  def new
      # renders login-page
  end

  def create
    # Finds the user from the db
    user = User.find_by username: params[:username]
    if user.nil?
        redirect_to :back, notice: "User #{params[:username]} does not exist!"
    else
      # Saves user_id for this session (if there is a user)
      session[:user_id] = user.id #if user
      # Redirects user to its own page
      redirect_to user, notice: "Welcome back #{params[:username]}!"
    end
  end

  def destroy
    # Uninitialize session
    session[:user_id] = nil
    # Redirect to main page
    redirect_to :root
  end

end
