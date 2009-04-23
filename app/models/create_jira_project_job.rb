require 'jira_lib/jira_interface.rb'
require 'benchmark_http_requests'

class CreateJiraProjectJob < Struct.new(:name, :shortname, :description, :login, :url, :is_pri)
  def perform
    JiraInterface.new.create_proj_default_perm(name, shortname, description, login, url, is_pri)
  end
end  