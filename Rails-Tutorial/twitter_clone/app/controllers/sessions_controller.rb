class SessionsController < ApplicationController
  def new
    # renders the login form, 'sessions/new' by default
  end

  def create
    # log the user in by creating the session
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # return an error - use 'flash.now' for rendered views - contents disappear as soon as there's an additional request.
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    # log the user out by destroying the session
    log_out if logged_in?
    redirect_to root_path
  end
end
