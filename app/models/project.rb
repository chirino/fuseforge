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

class Project < ActiveRecord::Base
  RECENT_PROJECTS_LIMIT = 5
  MOST_ACTIVE_PROJECTS_LIMIT = 4
  
  #Caching stuff
  FOUR_HOURS = 14400
  @@most_active = @@most_active_time =  nil
  
  acts_as_taggable_on :tags
  
  has_friendly_id :shortname
    
  has_one :featured_project, :dependent => :destroy
  has_one :issue_tracker, :dependent => :destroy
  has_one :repository, :dependent => :destroy
  has_one :git_repo, :dependent => :destroy
  has_one :web_dav_location, :dependent => :destroy
  has_one :forum, :dependent => :destroy
  has_one :wiki, :dependent => :destroy
  has_one :deployment_status, :dependent => :destroy
  
  has_many :news_items, :class_name => "ProjectNewsItem", :dependent => :destroy
  has_many :prospective_members, :class_name => "ProspectiveProjectMember", :dependent => :destroy
  has_many :mailing_lists, :dependent => :destroy
  
  has_many :groups, :class_name => "ProjectGroup", :dependent => :destroy do
    def users
      all.collect { |x| x.users }.flatten.uniq
    end
  end
  
  has_many :admin_groups, :class_name => "ProjectAdminGroup" do
    def default
      find_by_name(proxy_owner.default_admin_group_name)
    end
    
    def user_names
      all.collect { |x| x.user_names }.flatten.uniq
    end
      
    def users
      all.collect { |x| x.users }.flatten.uniq
    end
    
    def group_names
      all.collect { |x| x.name }
    end  
  end
  
  has_many :member_groups, :class_name => "ProjectMemberGroup" do
    def default
      find_by_name(proxy_owner.default_member_group_name)
    end
      
    def user_names
      all.collect { |x| x.user_names }.flatten.uniq
    end

    def users
      all.collect { |x| x.users }.flatten.uniq
    end

    def group_names
      all.collect { |x| x.name }
    end  
  end
  
  belongs_to :license, :class_name => "ProjectLicense", :foreign_key => "license_id"
  belongs_to :status, :class_name => "ProjectStatus", :foreign_key => "project_status_id"
  belongs_to :maturity, :class_name => "ProjectMaturity", :foreign_key => "project_maturity_id"
  belongs_to :category, :class_name => "ProjectCategory", :foreign_key => "project_category_id"
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
  
  has_attached_file :image, 
    :url => "/attachments/:class/:attachment/:id/:style_:basename.:extension",
    :path => ":rails_root/public/attachments/:class/:attachment/:id/:style_:basename.:extension",      
    :default_url => "/images/missing_project_:style.gif",
    :styles => { :medium => "160x160#", :small => "150x150#", :thumb => "70x70#" }
  
  named_scope :public, :conditions => { :is_private => false }
  named_scope :visibile_to, lambda { |user| 
    groups = user ? user.crowd_group_names : []
    { 
      :select => "DISTINCT projects.*",
      :joins => "LEFT OUTER JOIN `project_groups` ON project_groups.project_id = projects.id",
      :conditions => ['project_groups.name IN(?) OR projects.is_private=0', groups],
    } 
  }
  named_scope :active, lambda { { :conditions => ['project_status_id = ?', ProjectStatus.active.id] } }
  named_scope :inactive, lambda { { :conditions => ['project_status_id = ?', ProjectStatus.inactive.id] } }
  named_scope :unapproved, lambda { { :conditions => ['project_status_id = ?', ProjectStatus.unapproved.id] } }
  named_scope :approved, lambda { { :conditions => ['project_status_id != ?', ProjectStatus.unapproved.id] } }  
  named_scope :recent, :limit => RECENT_PROJECTS_LIMIT, :order => 'created_at desc'

  validates_presence_of :name, :shortname, :description, :status, :maturity, :category, :license
  validates_presence_of :other_license_url, :if => Proc.new { |x| x.license_id == ProjectLicense.other.id }
  
  validates_uniqueness_of :name, :shortname
  validates_format_of :shortname, :with => /\A([A-Z0-9]+)\Z/, :allow_blank => true
  
  validates_associated :status, :maturity, :updated_by, :license
  validates_associated :created_by, :on => :create
  
  validates_length_of :name, :minimum => 3
  validates_length_of :shortname, :within => 3..16
  
  validates_acceptance_of   :terms_and_conditions, :if => :allow_terms_and_conditions_validation?, :on => :create, 
   :message => 'must be checked'
  
  def before_validation_on_create
    self.status = ProjectStatus.unapproved
  end
  
  def before_save
    featured_project.destroy if is_private? and not featured_project.blank?
    deploy if is_private_changed? ||name_changed? || description_changed?
  end
  
  def before_create
    @accepted_terms_at = Time.now if @terms_and_conditions == '1'
  end
    
  def after_create
    Notifier.deliver_project_creation_notification(self)
  end
  
  def name=(value)
    forum.change_name(value) if (value != read_attribute(:name)) and not new_record? and forum.internal_supported?
    write_attribute(:name, value)
  end  
  
  def description=(value)
    forum.change_description(value) if (value != read_attribute(:description)) and not new_record? and forum.internal_supported?
    write_attribute(:description, value)
  end  
  
  def is_active?
    status == ProjectStatus.active
  end  
  
  def accepted_terms?
    not @accepted_terms_at.blank?
  end

  # Make sure shortname cannot be changed once it is set.
  def shortname=(value)
    write_attribute(:shortname, value) if read_attribute(:shortname).blank?
  end  
  
  def approve
    add_default_groups
    add_default_mailing_lists
    self.status = ProjectStatus.active
    self.deployment_status = DeploymentStatus.new
    save
    deploy
    Notifier.deliver_project_approval_notification(self)
  end  
  
  def inactivate
    groups.reject { |group| group.default? }.each { |group| group.destroy }
    admin_groups.default.user_names.each { |name| admin_groups.default.remove_user(name) }
    member_groups.default.user_names.each { |name| member_groups.default.remove_user(name) }
    self.status = ProjectStatus.inactive
    save    
  end  

  def administrators
    admin_groups.user_names
  end

  def find_administrator_by_user_id(user_id)
    user = User.find(user_id)
    administrators.include?(user) ? user : nil
  end
  
  def members
    member_groups.user_names
  end
  
  def find_member_by_user_id(login)
    members.include?(login) ? user : nil
  end
  
  def users
    groups.users
  end
  
  def approved?
    status != ProjectStatus.unapproved
  end
  
  # def default_administrators
  #   admin_groups.default.user_names
  # end
  #    
  # def default_members
  #   member_groups.default.user_names
  # end
  #   
  # def add_administrator(login)
  #   admin_groups.default.add_user(login)
  # end
  #   
  # def remove_administrator(login)
  #   admin_groups.default.remove_user(login)
  # end
  # 
  # def add_member(login)
  #   member_groups.default.add_user(login)
  # end
  #   
  # def remove_member(login)
  #   member_groups.default.remove_user(login)
  # end

  def default_admin_group_name
    @default_admin_group_name ||=  "#{ProjectGroup::DEFAULT_PREFIX}-#{shortname.downcase}-#{ProjectGroup::DEFAULT_ADMIN_SUFFIX}"
  end
  
  def default_member_group_name
    @default_member_group_name ||= "#{ProjectGroup::DEFAULT_PREFIX}-#{shortname.downcase}-#{ProjectGroup::DEFAULT_MEMBER_SUFFIX}"
  end  
  
  def internal_url
    "#{FORGE_URL}/projects/#{shortname.downcase}"
  end
  
  def unapproved_url
    "#{FORGE_URL}/unapproved_projects/#{shortname.downcase}"
  end  
  
  def external_website
    external_url.blank? ? web_dav_location.website_url : external_url
  end    
  
  def self.find_unapproved_by_id(project_shortname)
    self.find(:first, :conditions => ['shortname = ? AND project_status_id = ?', project_shortname.upcase, ProjectStatus.unapproved.id])
  end 
  
  def self.unfeatured
    self.public.approved - FeaturedProject.projects
  end
  
  def self.unfeatured_options_for_select
    self.unfeatured.collect { |x| [x.name, x.id] }
  end
  
  def self.most_active
    if @@most_active.blank? or @@most_active_time.blank? or (@@most_active_time < Time.now.ago(FOUR_HOURS))
      @@most_active = self.public.approved.sort { |a, b| 
       b.repository.commits <=> a.repository.commits }[0...MOST_ACTIVE_PROJECTS_LIMIT]
      @@most_active_time = Time.now
    end
    @@most_active   
  end
      
  def key
    self.shortname.downcase
  end
      
  def deploy
    # Don't deploy inactive projects...
    return unless is_active?  
    # Don't setup a deploy if a job is allready setup.
    return if deployment_status.next > deployment_status.last && !deployment_status.job.nil?
    deployment_status.next = deployment_status.last+1
    deployment_status.job = send_later :method=>:deploy_nodelay, :run_at=>(Delayed::Job.db_time_now + 60*2)
    deployment_status.save
  end
  
  def deploy_nodelay
    deployment_status.last = deployment_status.next
    deployment_status.job=nil;
    deployment_status.save
    
    resources = [repository, git_repo, web_dav_location, wiki, issue_tracker]
    mailing_lists.each do  |ml|
      resources << ml
    end
    resources << forum if forum.internal_supported?
    
    first_error=nil
    resources.each do |resource|
      # try to deploy all the resources..
      begin 
        resource.create_internal
        logger.flush
      rescue => e
        first_error = e if first_error==nil
        logger.error """Deployment error: #{e}\n#{e.backtrace.join("\n")}"""
      end
    end
    
    # But throw the first error the we caught
    raise first_error if first_error
  end
  
  private
  
  def add_default_groups
    g = ProjectAdminGroup.new(:name => default_admin_group_name)
    admin_groups << g
    g.add_user(created_by.login)
    g = ProjectMemberGroup.new(:name => default_member_group_name)
    member_groups << g
    g.add_user(created_by.login)
    member_groups << ProjectMemberGroup.new(:name => CrowdGroup.company_employee_group.name)
  end
  
  def add_default_mailing_lists
    dev_list = MailingList.new( :name => "dev", :use_internal=>true )
    dev_list.project = self
    dev_list.save
    
    commits_list = MailingList.new( :name => "commits", :use_internal=>true, :internal_replyto=>dev_list.post_address )
    commits_list.project = self
    commits_list.save
  end
    
  def allow_terms_and_conditions_validation?
    @accepted_terms_at.blank?
  end
end
