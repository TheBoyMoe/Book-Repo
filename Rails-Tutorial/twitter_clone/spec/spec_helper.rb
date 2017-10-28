# simplecov setup
require 'simplecov'
SimpleCov.start

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

end

def is_logged_in?
  !session[:user_id].nil?
end

def log_in_as(user)
  session[:user_id] = user.id
end
