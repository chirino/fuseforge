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

FUSESOURCE_URL = "http://localfusesource.com:4000/"
FUSEFORGE_URL = "http://fuseforge.localfusesource.com:3000"
REDIRECT_BACK_COOKIE_DOMAIN_NAME = '.localfusesource.com'
CROWD_COOKIE_DOMAIN_NAME = '.localfusesource.com'

BROWSE_ISSUES_URL = 'http://forge.fusesourcedev.com/issues/browse'
REPO_BASE_PATH = '/Users/jamey/work/chariot/iona/fuseforge/repos'
CONFLUENCE_URL = "http://forge.fusesourcedev.com"
JIRA_URL = "http://forge.fusesourcedev.com"


