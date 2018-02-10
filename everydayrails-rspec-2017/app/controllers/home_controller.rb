class HomeController < ApplicationController

  # serve up the home page to users not yet signed in
  # ApplicationController implements 'authenticate_user!' as a 'before_action'
  skip_before_action :authenticate_user!

  def index
  end

  def new
  end
end
