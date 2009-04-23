require 'net/http'
require 'uri'
require 'benchmark_http_requests'
require 'yaml'

class User < ActiveRecord::Base
  acts_as_tagger
  
  has_one :prospective_project_member
  
  belongs_to :phpbb_user, :class_name => "PhpbbUser", :foreign_key => "phpbb_user_id"

  # Virtual attributes for data stored in the external datastore
  # attr_accessor :password, :first_name, :last_name, :email, :company, :title, :phone, :country
  
  def self.authenticate_with_crowd_token(crowd_token, request)
    return false if crowd_token.nil?

    # Changed the call to use HTTP_X_FORWARDED_FOR because we are behind a proxy server.  
    unless RAILS_ENV == 'development'  
      return false unless Crowd.new.valid_user_token?(crowd_token, request.user_agent, 
       request.env['HTTP_X_FORWARDED_FOR'].split(',').first)      
    end

    begin
      crowd_user = Crowd.new.find_by_token(crowd_token) # throws SOAP::FaultError
    rescue SOAP::FaultError
      logger.warn "Crowd Error: #{$!}"
      return false
    end

    return false unless CrowdGroup.registered_user_group.user_names.include?(crowd_user.name)

    rc = self.find_or_create_by_login(crowd_user.name)
    rc.crowd_token = crowd_token
    rc.data_refresh(crowd_user)
    rc.save
    return rc
  end
  
  # dummy method for restful_authentication plugin
  def self.authenticate(username, password)
    return nil
  end
  
  def self.find_or_create_by_crowd_login(crowd_login)
    begin
      crowd_user = Crowd.new.find_by_name(crowd_login) # throws SOAP::FaultError
    rescue SOAP::FaultError
      logger.warn "Crowd Error: #{$!}"
      return false
    end

    return false unless CrowdGroup.registered_user_group.user_names.include?(crowd_user.name)

    rc = self.find_or_create_by_login(crowd_user.name)
    rc.data_refresh(crowd_user)
    rc.save
    return rc
  end  
  
  def data_refresh(crowd_user)   
    @crowd_user = crowd_user
    self.first_name = @crowd_user.first_name
    self.last_name = @crowd_user.last_name
    self.email = @crowd_user.email
    
    @crowd_group_names = Crowd.new.find_group_memberships(@crowd_user.name)
    self.groups_cache = YAML::dump(@crowd_group_names)
  end
  
  def crowd_group_names
    unless @crowd_group_names
      if self.groups_cache
        @crowd_group_names = YAML::load(self.groups_cache)
      else
        @crowd_group_names = Crowd.new.find_group_memberships(self.login)
      end
    end
    @crowd_group_names
  end
  
  def self.is_registered_user?(crowd_login)
    CrowdGroup.registered_user_group.user_names.include?(crowd_login)
  end
      
  def is_registered_user?
    crowd_group_names.index(CrowdGroup.registered_user_group.name)!=nil 
    #CrowdGroup.registered_user_group.user_names.include?(self.login)
  end
  
  def is_subscribing_customer?
    # TODO:  How do we determine what a subscribing customer is?
    true
  end
  
  def is_company_employee?
    crowd_group_names.index(CrowdGroup.company_employee_group.name)!=nil 
#    CrowdGroup.company_employee_group.user_names.include?(self.login)
  end
  
  def is_jira_fuseforge_developer?
    crowd_group_names.index(CrowdGroup.jira_developer_group.name)!=nil 
#    CrowdGroup.jira_developer_group.user_names.include?(self.login)
  end  
    
  def is_confluence_fuseforge_user?
    crowd_group_names.index(CrowdGroup.confluence_user_group.name)!=nil 
#    CrowdGroup.confluence_user_group.user_names.include?(self.login)
  end  
    
  def is_project_administrator?
    self.is_site_admin? || (not ProjectAdminGroup.group_names.to_set.intersection(crowd_group_names).empty?)
  end
  
  def is_project_administrator_for?(project)
    self.is_site_admin? || (not project.admin_groups.group_names.to_set.intersection(crowd_group_names).empty?)
  end  

  def is_project_member?
    self.is_site_admin? || (not ProjectMemberGroup.group_names.to_set.intersection(crowd_group_names).empty?)
  end
  
  def is_project_member_for?(project)
    self.is_site_admin? || (not project.member_groups.group_names.to_set.intersection(crowd_group_names).empty?)
  end  

  def is_site_admin?
    crowd_group_names.index(CrowdGroup.forge_admin_group.name)!=nil 
#    CrowdGroup.forge_admin_group.user_names.include?(self.login)
  end
  
  def projects
    proj_arr = []
    crowd_group_names.each do |group_name|
      if group_name =~ /forge-(.*)-[admins|members]/
        if proj = Project.find_by_shortname($1)
          proj_arr << proj unless proj_arr.include?(proj)
        end
      end
    end    
    proj_arr
  end
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end  
    
end