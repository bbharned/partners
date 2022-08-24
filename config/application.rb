require_relative 'boot'

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Partners
  class Application < Rails::Application

    config.assets.paths << "#{Rails.root}/app/assets/videos"
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.active_record.cache_versioning = true
    config.action_dispatch.use_authenticated_cookie_encryption = true
    config.active_support.use_authenticated_message_encryption = true
    config.action_controller.default_protect_from_forgery = true
    config.active_record.sqlite3.represent_boolean_as_integer = true
    config.active_support.use_sha1_digests = true
    config.action_view.form_with_generates_ids = true
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # config.action_mailer.deliver_later_queue_name = 'default_mailer_queue'

    config.before_configuration do
	  env_file = File.join(Rails.root, 'config', 'local_env.yml')
	  YAML.load(File.open(env_file)).each do |key, value|
	    ENV[key.to_s] = value
	  end if File.exists?(env_file)
	end

  end
end
