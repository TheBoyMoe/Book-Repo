class AddCounterCacheToStories < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :votes_count, :integer, default: 0
    Story.all.each do |s|
      s.update_attribute :votes_count, s.votes.count
    end
  end
end
