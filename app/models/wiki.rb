require 'confluence_lib/confluence_interface.rb'
require 'benchmark_http_requests'

class Wiki < ActiveRecord::Base
  belongs_to :project

  CONFLUENCE_INTERNAL_URL = CONFLUENCE_URL + '/display/'
  
  def before_save
    self.external_url = '' if use_internal?
  end
  
  def after_create
  end
  
  def before_destroy
    return true unless exists_internally?  
    
    conf_inter = ConfluenceInterface.new
    conf_inter.login
    conf_inter.remove_space(self.project.shortname)   
    conf_inter.logout
  end
  
  def is_active?
    use_internal? or not external_url.blank?
  end
  
  def internal_url
    CONFLUENCE_INTERNAL_URL + "#{self.project.shortname}/Home"
  end  
  
  def exists_internally?
    conf_inter = ConfluenceInterface.new
    conf_inter.login
    exist = conf_inter.space_exists?(self.project.shortname)
    conf_inter.logout
    exist
  end
  
  def create_internal
    return true if not use_internal? or exists_internally?

    confluence_interface = ConfluenceInterface.new
    confluence_interface.login
    confluence_interface.create_space(self.project.shortname, 
                   self.project.name,self.project.name + " Confluence Space",
                   CONFLUENCE_INTERNAL_URL,
                   self.project.is_private?)
    confluence_interface.logout
  rescue => error
    logger.error """Error creating the confluence wiki: #{error}\n#{error.backtrace.join("\n")}"""
  end

  def url
    use_internal? ? internal_url : external_url
  end
  
  def get_latest_activity
    conf_inter = ConfluenceInterface.new
    conf_inter.login
    latest_act = conf_inter.get_latest_for_space(self.project.shortname)
    conf_inter.logout
    latest_act
  end

  def make_private
    reset_permissions(true)
  end
  
  def make_public
    reset_permissions(false)
  end
  
  def reset_permissions(reset_to_private)
    return true unless use_internal?
    
    confluence_interface = ConfluenceInterface.new
    confluence_interface.login
    confluence_interface.reset_space_perm(project.shortname, reset_to_private)
    confluence_interface.logout
    
  rescue => error
    logger.error """Error updating the confluence wiki: #{error}\n#{error.backtrace.join("\n")}"""
  end  
end
