class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current_user
  helper_method :logged_in? # 'helper_method' makes the method available in views and controllers

  protected
    def current_user
      return unless session[:user_id]
      # find returns an error if the user can't be found, where returns nil
      @current_user = User.where(id: session[:user_id]).first

      # log user access using Rails.logger object
      # Rails.logger.info "#{@current_user.name} requested #{request.fullpath} on #{Time.now}"
    end

    def logged_in?
      !@current_user.nil?
    end

    def ensure_login
      return true if logged_in?
      session[:return_to] = request.fullpath
      redirect_to new_session_path and return false
    end
end
