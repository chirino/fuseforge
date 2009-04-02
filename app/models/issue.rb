require 'jira_lib/jira_interface.rb'

class Issue
  RECENT_ISSUES_LIMIT = 5
  
  def self.recent(issue_tracker, internal_url)
    issues = JiraInterface.new.get_issues_for_project(issue_tracker.project.shortname, internal_url)
    issues
  end    
end