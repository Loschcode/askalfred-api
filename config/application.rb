require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie" # for ActiveAdmin
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AskalfredApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.paths.add File.join('app', 'services'), glob: File.join('**', '*.rb')
    config.paths.add File.join('app', 'workers'), glob: File.join('**', '*.rb')

    config.autoload_paths += Dir[
      Rails.root.join('app', 'services'),
      Rails.root.join('app', 'workers'),
      Rails.root.join('lib')]

    # this is for Sidekiq
    config.eager_load_paths += Dir[
      Rails.root.join('app', 'services'),
      Rails.root.join('app', 'workers'),
      Rails.root.join('lib')
    ]

    ENV.update YAML.load_file('config/application.yml')[Rails.env] rescue {}

    config.api_only = true
    config.skylight.probes << 'graphql'

    # below is for ActiveAdmin
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Flash

    config.action_cable.disable_request_forgery_protection = true
  end
end
