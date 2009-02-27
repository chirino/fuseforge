# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
#config.action_view.cache_template_loading            = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

if ['sourcedev', 'forgedev'].include?(Socket.gethostname)
  FUSESOURCE_URL = "http://fusesourcedev.com" 
  CONFLUENCE_URL = FUSEFORGE_URL = "http://fusesourcedev.com/forge"
  REDIRECT_BACK_COOKIE_DOMAIN_NAME = CROWD_COOKIE_DOMAIN_NAME = "fusesourcedev.com" 
  JIRA_URL = "http://fusesourcedev.com"
  config.action_mailer.default_url_options = { :host => "fusesourcedev.com" }
else
  FUSESOURCE_URL = "http://fusesource.com" 
  CONLUENCE_URL = FUSEFORGE_URL = "http://fusesource.com/forge"
  REDIRECT_BACK_COOKIE_DOMAIN_NAME = CROWD_COOKIE_DOMAIN_NAME = "fusesource.com" 
  JIRA_URL = "http://fusesource.com"
  config.action_mailer.default_url_options = { :host => "fusesource.com" }  
end