class StoriesController < ApplicationController
  before_action :set_story, only: [:show]
  before_action :ensure_login, only: [:new, :create]

	def index
		@story = Story.all.order('RANDOM()').first
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    if @story.save
    	redirect_to stories_path, notice: 'Story submission succeeded'
		else
			render :new
		end
  end

  private
    def story_params
      params.require(:story).permit(:name, :link)
    end

		def set_story
			@story = Story.find(params[:id])
		end
end
