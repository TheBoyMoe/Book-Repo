ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

	# utility methods - avoids duplicating the code in the tests - available to all tests
  def login_user
    post session_path, params: { email: users(:glenn).email, password: 'sekrit'}
  end

  def logout_user
    delete session_path
  end
end
