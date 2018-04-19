class User < ApplicationRecord
  # 1. adds .password and .password_confirmation methods
  # adding validations to ensure the two match
  # 2. encrypts the password, stored in the password_digest field
  # 3. add the .authenticate instance method to the user model
  # NOTE: requires the bycrypt gem
  has_secure_password
end
