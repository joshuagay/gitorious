Gitorious::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # config.threadsafe!

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.action_dispatch.rack_cache = nil

  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # See everything in the log (default is :info)
  config.log_level = :warn

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  config.log_tags = [
    -> request { Time.now.to_i },
    -> request { $$ },
    :uuid,
  ]

  # Use a different cache store in production
  config.cache_store = :mem_cache_store

  # Disable Rails's static asset server (Apache or nginx will already do this).
  config.serve_static_assets = false

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Make sure this is writeable by your webserver user
  cache_dir = Rails.root + 'public/cache'
  config.action_controller.page_cache_directory = cache_dir

  config.react.variant = :production
end
