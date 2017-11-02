class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)} # => newest -> oldest (latest first)
  mount_uploader :picture, PictureUploader # => associate CarrierWave's uploader class with the model

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
