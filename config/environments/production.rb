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

FUSESOURCE_URL = Socket.gethostname == 'forgedev' ? "http://fusesourcedev.com/" : "http://fusesource.com/" 
FUSEFORGE_URL = Socket.gethostname == 'forgedev' ? "http://fusesourcedev.com/forge" : "http://fusesource.com/forge"
REDIRECT_BACK_COOKIE_DOMAIN_NAME = Socket.gethostname == 'forgedev' ? ".fusesourcedev.com" : ".fusesource.com" 
CROWD_COOKIE_DOMAIN_NAME = Socket.gethostname == 'forgedev' ? ".fusesourcdev.com" : ".fusesource.com" 
CONFLUENCE_URL = Socket.gethostname == 'forgedev' ? "http://fusesourcedev.com/forge" : "http://fusesource.com/forge"
JIRA_URL = Socket.gethostname == 'forgedev' ? "http://fusesourcedev.com" : "http://fusesource.com"
