class StaticController < ApplicationController

  def home
    if logged_in?
      # by default renders the view corresponding to the action 'app/views/static/home'
      @micropost = current_user.microposts.build
      # display the users feed on the home page
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about

  end

  def contact

  end
end
