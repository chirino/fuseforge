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

FUSESOURCE_DOMAIN="fusesource.com"

FUSESOURCE_URL="http://#{FUSESOURCE_DOMAIN}"
FORGE_URL = "#{FUSESOURCE_URL}/forge"
CROWD_URL = "#{FUSESOURCE_URL}/crowd"
JIRA_URL = "#{FUSESOURCE_URL}/issues"
CONFLUENCE_URL = '#{FUSESOURCE_URL}/wiki'
CROWD_COOKIE_DOMAIN_NAME = ".#{FUSESOURCE_DOMAIN}" 

JIRA_CONFIG = { :url => JIRA_URL, :login=>'forgeadmin', :password=>'forgeadmin' }
CONFLUENCE_CONFIG = { :url => CONFLUENCE_URL, :login=>'forgeadmin', :password=>'forgeadmin' }
DAV_CONFIG = SVN_CONFIG = {
  :user=> "www-data",
}
MAILMAN_CONFIG = {
  :user=>'list',
  :domain=>"fusesource.org",
  :management_url=>"#{FUSESOURCE_URL}/forge/mailman"
}
FORUM_CONFIG = {
  :user => "www-data", 
  :path => '/data/phpBB3',
}
GIT_CONFIG = {
  :user => "git",
  :host => "forge.#{FUSESOURCE_DOMAIN}",
  :home => '/var/forge/git',
  :forge_git_path => '/data/fuseforge/current/script/forge-git'  
}
config.action_mailer.default_url_options = { :host => FUSESOURCE_DOMAIN }
