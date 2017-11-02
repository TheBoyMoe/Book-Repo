class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # make the SessionsHelper module available in all controllers,
  # by default available in all views
  include SessionsHelper

  # confirm loged in user
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in'
      redirect_to login_url
    end
  end
end
