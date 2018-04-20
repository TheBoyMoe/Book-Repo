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
    # associate the story with the approriate user
    # @current_user is set by current_user method of application controller
    @story = @current_user.stories.build(story_params)
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
