require 'net/http'
require 'uri'

class User < ActiveRecord::Base
  acts_as_tagger
  
  has_one :prospective_project_member
  has_many :wiki_pages
  
  belongs_to :phpbb_user, :class_name => "PhpbbUser", :foreign_key => "phpbb_user_id"

  # Virtual attributes for data stored in the external datastore
  attr_accessor :password, :first_name, :last_name, :email, :company, :title, :phone, :country
  
  def self.authenticate_with_crowd_token(crowd_token, request)
    return false if crowd_token.nil?

  # Changed the call to use HTTP_X_FORWARDED_FOR because we are behind a proxy server.    
    return false unless Crowd.new.valid_user_token?(crowd_token, request.user_agent, request.remote_ip)      
#    return false unless Crowd.new.valid_user_token?(crowd_token, request.user_agent, 
#     request.env['HTTP_X_FORWARDED_FOR'].split(',').first)      

    begin
      crowd_user = Crowd.new.find_by_token(crowd_token) # throws SOAP::FaultError
    rescue SOAP::FaultError
      return false
    end

    return false unless RegisteredUserGroup.new.user_names.include?(crowd_user.name)

    self.find_or_create_by_login(crowd_user.name)
  end
  
  # dummy method for restful_authentication plugin
  def self.authenticate(username, password)
    return nil
  end
  
  def self.find_or_create_by_crowd_login(crowd_login)
    begin
      crowd_user = Crowd.new.find_by_name(crowd_login) # throws SOAP::FaultError
    rescue SOAP::FaultError
      return false
    end

    return false unless RegisteredUserGroup.new.user_names.include?(crowd_user.name)

    self.find_or_create_by_login(crowd_user.name)
  end  
  
  def self.is_registered_user?(crowd_login)
    RegisteredUserGroup.new.user_names.include?(crowd_login)
  end
    
  def after_initialize
    unless self.login.blank?
      begin
        @crowd_user = Crowd.new.find_by_name(self.login)
      rescue SOAP::FaultError
      end

      @crowd_group_names = Crowd.new.find_group_memberships(@crowd_user.name)  
      populate_crowd_attributes
    end
  end
  
  def after_create
    JiraFuseforgeDeveloperGroup.new.add_user(self)
    ConfluenceFuseforgeUserGroup.new.add_user(self)
  end  
  
  def populate_crowd_attributes    
    self.first_name = @crowd_user.first_name
    self.last_name = @crowd_user.last_name
    self.email = @crowd_user.email
    self.company = @crowd_user.company
    self.title = @crowd_user.title
    self.phone = @crowd_user.phone
    self.country = @crowd_user.country
  end

  def is_registered_user?
    RegisteredUserGroup.new.user_names.include?(self.login)
  end
  
  def is_subscribing_customer?
    # TODO:  How do we determine what a subscribing customer is?
    true
  end
  
  def is_company_employee?
    CompanyEmployeeGroup.new.user_names.include?(self.login)
  end
  
  def is_jira_fuseforge_developer?
    JiraFuseforgeDeveloperGroup.new.user_names.include?(self.login)
  end  
    
  def is_confluence_fuseforge_user?
    ConfluenceFuseforgeUserGroup.new.user_names.include?(self.login)
  end  
    
  def is_project_administrator?
    self.is_site_admin? || (not ProjectAdminGroup.group_names.to_set.intersection(@crowd_group_names).empty?)
  end
  
  def is_project_administrator_for?(project)
    self.is_site_admin? || (not project.admin_groups.group_names.to_set.intersection(@crowd_group_names).empty?)
  end  

  def is_project_member?
    self.is_site_admin? || (not ProjectMemberGroup.group_names.to_set.intersection(@crowd_group_names).empty?)
  end
  
  def is_project_member_for?(project)
    self.is_site_admin? || (not project.member_groups.group_names.to_set.intersection(@crowd_group_names).empty?)
  end  

  def is_site_admin?
    SiteAdminGroup.new.user_names.include?(self.login)
  end
  
  def projects
    Project.approved.select { |project| project.users.include?(self) }
  end
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end  
  
  def crowd_group_names
    @crowd_group_names
  end
end