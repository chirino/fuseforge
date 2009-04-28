# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

FORGE_URL = "http://fusesourcedev.com/forge"
CROWD_URL = "http://fusesourcedev.com/crowd"
FUSESOURCE_URL = "http://fusesourcedev.com" 
JIRA_URL = "http://fusesourcedev.com/issues"
CONFLUENCE_URL = 'http://fusesourcedev.com/wiki'
JIRA_CONFIG = { :url => JIRA_URL, :login=>'forgeadmin', :password=>'forgeadmin' }
CONFLUENCE_CONFIG = { :url => CONFLUENCE_URL, :login=>'forgeadmin', :password=>'forgeadmin' }
MAILING_LIST_DOMAIN = "fusesource.org"

CROWD_COOKIE_DOMAIN_NAME = ".fusesourcedev.com" 

DAV_CONFIG = SVN_CONFIG = {
  :user=> "www-data",
}
MAILMAN_CONFIG = {
  :user=>'list'
}
FORUM_CONFIG = {
  :user => "www-data", 
  :path => '/data/phpBB3',
}


config.action_mailer.default_url_options = { :host => "fusesourcedev.com" }
