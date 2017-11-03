class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  # associations
  has_many :microposts, dependent: :destroy # => destroy all user posts upon destroying user

  has_many :active_relationships, class_name:  "Relationship",  foreign_key: "follower_id", dependent:   :destroy


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

  def activate
    #  update_attribute(:activated,    true)
    #  update_attribute(:activated_at, Time.zone.now)
    # make a single database call
    update_columns(activated: true, activated_at: Time.zone.now)
  end

   # Sends activation email.
  def send_activation_email
     UserMailer.account_activation(self).deliver_now
  end

  # create the reset digest and update the user record
  def create_reset_digest
    self.reset_token = User.new_token
    # update_attribute(:reset_digest,  User.digest(reset_token))
    # update_attribute(:reset_sent_at, Time.zone.now)
    update_columns(reset_digest:  User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # check that the password was not sent more than 2 hours ago
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # return the users feed
  def feed
    Micropost.where("user_id = ?", id)
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
