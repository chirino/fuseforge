require 'confluence_lib/confluence_interface.rb'
class Wiki < ActiveRecord::Base
  belongs_to :project

  #TODO: remove the wiki_pages table
  has_many :wiki_pages, :dependent => :destroy
  
  CONFLUENCE_INTERNAL_PATH = 'wiki/display/'
  CONFLUENCE_INTERNAL_URL = CONFLUENCE_URL + '/' + CONFLUENCE_INTERNAL_PATH
  
  def before_save
    self.external_url = '' if use_internal?
  end
  
  def after_create
    #self.wiki_pages << WikiPage.create(:slug => 'Downloads', 
    # :body => 'Use this page to provide links to any downloads you wish to provide.')
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
  end  
end
