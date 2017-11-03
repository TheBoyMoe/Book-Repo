class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)} # => newest -> oldest (latest first)
  mount_uploader :picture, PictureUploader # => associate CarrierWave's uploader class with the model

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size


  private
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, 'should be less than 5MB')
      end
    end

end
