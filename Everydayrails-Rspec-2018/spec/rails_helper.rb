ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'capybara/rspec'
require 'paperclip/matchers'

ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # use Devise test helpers
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include RequestSpecHelper, type: :request

  config.include LoginSupport

  # filtering tagged specs
  # config.filter_run focus: true
  # config.run_all_when_everything_filtered = true # run whole suite when 'focus' not found

  config.filter_run_excluding slow: true # filter any tests tagged 'slow'

  # Add support for Paperclip's Shoulda matchers
  config.include Paperclip::Shoulda::Matchers

  # Clean up file uploads when test suite is finished
  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/spec/test_uploads/"])
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end