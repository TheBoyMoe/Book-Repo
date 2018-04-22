class TagsController < ApplicationController
  def show
    # fetch all stories with the particular tag
    @stories = Story.tagged_with(params[:id])
  end
end
