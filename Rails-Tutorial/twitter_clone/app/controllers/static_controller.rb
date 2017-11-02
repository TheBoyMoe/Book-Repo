class StaticController < ApplicationController
  def home
    # by default renders the view corresponding to the action 'app/views/static/home'
    @micropost = current_user.microposts.build if logged_in?
  end

  def help
  end

  def about

  end

  def contact

  end
end
