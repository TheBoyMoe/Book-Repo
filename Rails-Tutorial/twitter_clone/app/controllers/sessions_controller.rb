class SessionsController < ApplicationController
  def new
    # renders the login form, 'sessions/new' by default
  end

  def create
    # log the user in by creating the session
  end

  def destroy
    # log the user out by destroying he session
  end
end
