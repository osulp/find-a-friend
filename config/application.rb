require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Blog
  class Application < Rails::Application
    application_config = YAML.load_file('config/config.yml')|| {}
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
      g.test_framework :rspec,
        :fixtures => true,
        :view_specs => false,
        :helper_specs => false,
        :routing_specs => false,
        :controller_specs => true,
	:request_specs => true
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end

    config.rubycas.cas_base_url = application_config["rubycas"]["cas_base_url"]
    config.rubycas.validate_url = application_config["rubycas"]["validate_url"]
    config.rubycas.cas_destination_logout_param_name = application_config["rubycas"]["cas_destination_logout_param_name"]

    config.i18n.enforce_available_locales = true
    config.time_zone = 'Pacific Time (US & Canada)'
  end
end
