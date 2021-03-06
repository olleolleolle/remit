require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Remit
  mattr_accessor :version
  # Increase this version number if you want to force clients to reload.
  # The current version will be sent out to clients on deploy, and a
  # version change will force a reload.
  self.version = "0.3"

  class Application < Rails::Application

    # Required for message_bus.
    # https://github.com/SamSaffron/message_bus/issues/17
    config.middleware.delete Rack::Lock

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.generators do |g|
      g.factory_girl suffix: "factory"
    end
  end
end
