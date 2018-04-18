class Story < ApplicationRecord
  validates :name, :link, presence: true

  # customise has_many association
  has_many :votes do
    # return the last 6 votes
    def latest
      order('id DESC').limit(6)
    end
  end

  # override the default to_param method returning a simplfied version of the name instead of the ID
  def to_param
    # convert anything thats not an alpha-numeric char in to a '-' and append to the ID
    "#{id}-#{name.gsub(/\W/, '-').downcase}"
  end

end
