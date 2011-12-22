PSDB::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true
 
  # Compress JavaScript and CSS
  config.assets.compress = true
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :yui

  # Don't fallback to assets pipeline
  config.assets.compile = false
  config.assets.precompile +=  %w( application-all.css application-print.css application-ie.css formvalidataion.js )

  # Generate digests for assets URLs
  config.assets.digest = true

  # Mailer configuration
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address => "smtp1.gsi.de" }
end
