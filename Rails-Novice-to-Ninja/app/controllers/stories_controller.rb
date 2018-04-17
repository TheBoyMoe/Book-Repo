class StoriesController < ApplicationController
  def index
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    @story.save
    redirect_to stories_path
  end

  private
    def story_params
      params.require(:story).permit(:name, :link)
    end
end
