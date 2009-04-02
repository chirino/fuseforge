require 'net/http'
require 'uri'
require 'jira_lib/jira_interface.rb'

class IssueTracker < ActiveRecord::Base
  JIRA_INTERNAL_PATH = 'issues/browse/'
  JIRA_INTERNAL_URL = JIRA_URL + '/' + JIRA_INTERNAL_PATH

  belongs_to :project
  
  def before_save
    self.external_url = '' if use_internal?
  end
  
  def before_destroy
    return true unless exists_internally?
    
    JiraInterface.new.remove_project(self.project.shortname)
  end

  def is_active?
    use_internal? or not external_url.blank?
  end
  
  def exists_internally?
    JiraInterface.new.project_key_exists?(self.project.shortname)
  end  
  
  def create_internal
    return true if not use_internal? or exists_internally?

    Delayed::Job.enqueue CreateJiraProjectJob.new(project.name, project.shortname, project.description, project.created_by.login, 
     JIRA_INTERNAL_URL, project.is_private?)
  end  
  
  def make_private
    reset_permissions(true)
  end
  
  def make_public
    reset_permissions(false)
  end
  
  def reset_permissions(reset_to_private)
    return true unless use_internal?
    
    Delayed::Job.enqueue UpdateJiraProjectJob.new(project.shortname, reset_to_private)
  end
  
  def internal_url
    "#{JIRA_INTERNAL_URL}#{project.shortname}"
  end  
  
  def url
    use_internal? ? internal_url : external_url
  end

  def recent_issues
    Issue.recent(self,JIRA_INTERNAL_URL)
  end
  
  def private_scheme_name
    "private-#{project.shortname}-scheme"
  end

  def public_scheme_name
    "public-#{project.shortname}-scheme"
  end
end
