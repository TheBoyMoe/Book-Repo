class SessionsController < ApplicationController
  def new
    # renders the login form, 'sessions/new' by default
  end

  def create
    # log the user in by creating the session
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # log the user in & redirect to user's show page
      log_in(user) # sign_in user
      # remember(user) # create a persistent session
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # redirect_to user_path(user) # => '/users/:id'
      redirect_back_or(user) # => '/users/:id/edit' or '/user/:id' - default
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
