class SessionsController < ApplicationController

  def new
      # renders login-page
  end

  def create_oauth
    result = env["omniauth.auth"]
    #binding.pry
    user = User.find_by(username: result.info.nickname, provider: result.provider)
    if user
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back #{params[:username]}!"
    else
      user = User.create_user_with_omniauth(result.info.nickname, result.provider)
      session[:user_id] = user.id
      redirect_to user, :notice => "Welcome #{params[:username]}!"
    end
  end

  def create
    # Finds the user from the db
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password]) && !user.banned
      # Saves user_id for this session (if there is a user)
      session[:user_id] = user.id
      # Redirects user to its own page
      redirect_to user, notice: "Welcome back #{params[:username]}!"
    elsif !user || !user.authenticate(params[:password])
      redirect_to :back, notice: "Username and/or password mismatch"
    elsif user.banned
      redirect_to :back, notice:'Your account is frozen, please contact administrators!'
    end
  end

  def destroy
    # Uninitialize session
    session[:user_id] = nil
    # Redirect to main page
    redirect_to :root
  end

end
