class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  # callback method executed before saving the user(both creation and update)
  before_save :downcase_email

  # execute the method before creating the user
  before_create :create_activation_digest

  validates :name, presence: true, length: {maximum: 60}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

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
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # does the token match
  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end

  # refactored to handle activation_ as well as remember_digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # remove the saved token from the user record
  def forget
    update_attribute(:remember_digest, nil)
  end

  private
    def create_activation_digest
      # set activation_token and _digest on each new user, _digest will be saved to the database when the user is saved
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def downcase_email
      # self.email = email.downcase
      email.downcase!
    end

end
