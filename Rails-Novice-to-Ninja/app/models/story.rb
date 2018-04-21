class Story < ApplicationRecord
  validates :name, :link, presence: true
  after_create :create_initial_vote
  belongs_to :user

  # customise has_many association
  has_many :votes do
    # return the last 6 votes
    def latest
      order('id DESC').limit(6)
    end
  end
  
  # use ActiveRecord scopes as a means to define class methods with common queries
  scope :upcoming, -> { where('votes_count < 5').order('id DESC') }
  scope :popular, -> { where('votes_count >= 5').order('id DESC') }


  # override the default to_param method returning a simplfied version of the name instead of the ID
  def to_param
    # convert anything thats not an alpha-numeric char in to a '-' and append to the ID
    "#{id}-#{name.gsub(/\W/, '-').downcase}"
  end

  protected
    def create_initial_vote
      # we're able to use the 'votes' and 'user' attribute of the story model
      votes.create(user: user)
    end
end
