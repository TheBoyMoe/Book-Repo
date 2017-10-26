class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # make the SessionsHelper module available in all controllers,
  # by default available in all views
  include SessionsHelper
end
