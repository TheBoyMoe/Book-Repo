class HomeController < ApplicationController

  # serve up the home page to users not yet signed in
  skip_before_action :authenticate_user!

  def index
  end

  def new
  end
end
