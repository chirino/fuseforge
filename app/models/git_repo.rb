require 'command_executor'

class GitRepo < ActiveRecord::Base
  belongs_to :project
  
  def before_destroy
    # TODO: do some archiving of the git repo?
    true
  end
  
  def is_active?
    use_internal? || !external_anonymous_url.blank? || !external_commit_url.blank? 
  end
  
  def commit_url
    use_internal? ? internal_commit_url : external_commit_url
  end

  def anonymous_url
    use_internal? ? internal_anonymous_url : external_anonymous_url
  end

  def web_url
    use_internal? ? internal_web_url : external_web_url
  end
  
  def create_internal()
    return true if not use_internal?
    true
  rescue => error
    logger.error """Error creating the git repo: #{error}\n#{error.backtrace.join("\n")}"""
  end    
  
  def update_permissions
    return true if not use_internal?
    true
  rescue => error
    logger.error """Error update the svn permissions: #{error}\n#{error.backtrace.join("\n")}"""
  end
  
  private
  
  def key
    self.project.shortname.downcase
  end

  def repos_filepath
    "#{GIT_CONFIG[:home]}/repos"
  end

  def repo_filepath
    "#{repos_filepath}/#{key}.git"
  end
  
  def internal_commit_url
    "#{GIT_CONFIG[:user]}@#{GIT_CONFIG[:host]}:#{key}.git"
  end  

  def internal_anonymous_url
    "git://#{GIT_CONFIG[:host]}:#{key}.git"    
  end
  
  def internal_web_url
    "#{FORGE_URL}/git/#{key}.git"    
  end
  
end