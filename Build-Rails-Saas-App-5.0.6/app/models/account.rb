class Account < ApplicationRecord
  has_many :users, class_name: "user", foreign_key: "reference_id"
  validates :name, presence: true
end
