# ===========================================================================
# Copyright (C) 2009, Progress Software Corporation and/or its 
# subsidiaries or affiliates.  All rights reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ===========================================================================

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
PROJECT_HOMEPAGE_PATTERN="http://@PROJECT@.fusesourcedev.com"

FUSESOURCE_URL="http://#{FUSESOURCE_DOMAIN}"
FORGE_URL = "#{FUSESOURCE_URL}/forge"
CROWD_URL = "#{FUSESOURCE_URL}/crowd"
JIRA_URL = "#{FUSESOURCE_URL}/issues"
CROWD_COOKIE_DOMAIN_NAME = ".#{FUSESOURCE_DOMAIN}" 

FORGEADMIN_USER_LOGIN = "forgeadmin" unless defined? FORGEADMIN_USER_LOGIN
FORGEADMIN_USER_PASSWORD = "password" unless defined? FORGEADMIN_USER_PASSWORD

JIRA_CONFIG = { :url => JIRA_URL, :login=>FORGEADMIN_USER_LOGIN, :password=>FORGEADMIN_USER_PASSWORD }
CONFLUENCE_CONFIG = { :url => "#{FUSESOURCE_URL}/wiki", :login=>FORGEADMIN_USER_LOGIN, :password=>FORGEADMIN_USER_PASSWORD }

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
NEXUS_CONFIG = { :url => "http://#{FORGEADMIN_USER_LOGIN}:#{FORGEADMIN_USER_PASSWORD}@repo.#{FUSESOURCE_DOMAIN}/nexus" }

config.action_mailer.default_url_options = { :host => FUSESOURCE_DOMAIN }
