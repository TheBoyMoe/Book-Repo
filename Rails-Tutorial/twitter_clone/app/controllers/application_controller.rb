class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render html: 'Nothing to see here - just another Rails 5 app!'
  end
end
