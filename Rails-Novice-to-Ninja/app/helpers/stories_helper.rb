module StoriesHelper

  def story_list_heading
    story_type = case controller.action_name
                 when 'index' then 'front page story'
                 when 'bin' then 'upcoming story' 
                 end
    "showing #{ pluralize(@stories.count, story_type) }"
  end
end
