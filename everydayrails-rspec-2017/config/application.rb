require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Projects
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # generate only controller and model specs when running the generators
    # fixtures -> we'll enable when we test factories
    # view_specs -> we'll test through feature/integration specs
    # helper/routing_specs -> test in larger apps
    config.generators do |generator|
      generator.test_framework :rspec,
         fixtures: false,
         view_specs: false,
         helper_specs: false,
         routing_specs: false
    end
  end
end
