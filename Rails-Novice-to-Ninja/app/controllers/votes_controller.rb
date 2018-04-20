class VotesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @story = Story.find(params[:story_id])
    @story.votes.create(user: @current_user) # vote consists of id, user_id and story_id
    respond_to do |format|
      # fallback if browser has js blocked, skip_before_action req'd otherwise fails due to invalid security token
      format.html {redirect_to story_path(@story), notice: 'Vote was successfully cast.'}
      format.js {} # renders app/views/votes/create.js.erb
    end
  end

end
