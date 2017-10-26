class SessionsController < ApplicationController
  def new
    # renders the login form, 'sessions/new' by default
  end

  def create
    # log the user in by creating the session
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # log the user in & redirect to user's show page
    else
      # return an error - use 'flash.now' for rendered views - contents disappear as soon as there's an additional request.
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    # log the user out by destroying he session
  end
end
