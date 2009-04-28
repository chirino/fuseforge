# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

FORGE_URL = "http://fusesourcedev.com/forge"
CROWD_SOAP_URL = "http://fusesourcedev.com/crowd/services/SecurityServer"
FUSESOURCE_URL = "http://fusesourcedev.com" 
JIRA_URL = "http://fusesourcedev.com/issues"
CONFLUENCE_URL = 'http://fusesourcedev.com/wiki'
CROWD_COOKIE_DOMAIN_NAME = ".fusesourcedev.com" 

JIRA_CONFIG = { :url => JIRA_URL, :login=>'forgeadmin', :password=>'forgeadmin' }
CONFLUENCE_CONFIG = { :url => CONFLUENCE_URL, :login=>'forgeadmin', :password=>'forgeadmin' }
DAV_CONFIG = SVN_CONFIG = {
  :user=> "www-data",
}
MAILMAN_CONFIG = {
  :user=>'list'
  :domain=>"fusesourcedev.com"
}
FORUM_CONFIG = {
  :user => "www-data", 
  :path => '/data/phpBB3',
}

config.action_mailer.default_url_options = { :host => "fusesourcedev.com" }
