class StoriesController < ApplicationController
  before_action :set_story, only: [:show]
  before_action :ensure_login, only: [:new, :create]

	def index
    # return stories with 5 or more votes in desc order by id, newest first
		# @stories = fetch_stories('votes_count >= 5')

    @stories = Story.popular
  end

  def show
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

  def bin
    # @stories = fetch_stories('votes_count < 5')
    @stories = Story.upcoming
    render :index
  end

  protected
    def fetch_stories(conditions)
			# benchmark the retireval of stories and print to the development log
			results = Benchmark.measure do
      	@stories = Story.where(conditions).order('id DESC')
			end
			Rails.logger.info results
    end

  private
    def story_params
      params.require(:story).permit(:name, :link, :description, :tag_list)
    end

		def set_story
			@story = Story.find(params[:id])
		end
end
