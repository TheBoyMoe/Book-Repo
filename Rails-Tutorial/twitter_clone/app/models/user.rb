class User < ApplicationRecord
  attr_reader :remember_token

  before_save {self.email = email.downcase}
  # callback method executed before saving the user
  # before_create :create_remember_token

  validates :name, presence: true, length: {maximum: 60}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}

  has_secure_password

  # returns the hash digest of a random string
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # returns a random string token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # store a hashed version of the token in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_token, User.digest(self.remember_token))
  end


end
