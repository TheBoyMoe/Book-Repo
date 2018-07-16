class Project < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :notes
  has_many :tasks
  
  validates :name, presence: true, uniqueness: { scope: :user_id }
  
  # no two users can have a project with the same name
  # validates :name, presence: true, uniqueness: true

  def late?
    due_on.in_time_zone < Date.current.in_time_zone
  end
end
