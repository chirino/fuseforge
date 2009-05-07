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

FUSESOURCE_DOMAIN="fusesourcedev.com"

FUSESOURCE_URL="http://#{FUSESOURCE_DOMAIN}"
FORGE_URL = "#{FUSESOURCE_URL}/forge"
CROWD_URL = "#{FUSESOURCE_URL}/crowd"
JIRA_URL = "#{FUSESOURCE_URL}/issues"
CONFLUENCE_URL = '#{FUSESOURCE_URL}/wiki'
CROWD_COOKIE_DOMAIN_NAME = ".#{FUSESOURCE_DOMAIN}" 

JIRA_CONFIG = { :url => JIRA_URL, :login=>'forgeadmin', :password=>'password' }
CONFLUENCE_CONFIG = { :url => CONFLUENCE_URL, :login=>'forgeadmin', :password=>'password' }
DAV_CONFIG = SVN_CONFIG = {
  :user=> "www-data",
}
MAILMAN_CONFIG = {
  :user=>'list',
  :domain=>"fusesourcedev.com",
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
