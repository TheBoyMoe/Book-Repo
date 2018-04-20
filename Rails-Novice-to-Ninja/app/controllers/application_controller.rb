class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current_user

  protected
    def current_user
      return unless session[:user_id]
      # find returns an error if the user can't be found, where returns nil
      @current_user = User.where(id: session[:user_id]).first
    end
end
