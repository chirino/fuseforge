require 'jira_lib/jira_interface.rb'

class ProjectsController < ApplicationController
	skip_before_filter :login_required, :only => [:index, :show]

  before_filter :get_project, :only => [:show, :edit, :update, :destroy]
  before_filter :get_terms_and_conditions_text, :only => [:new, :create]
  
  deny :show, :edit, :update, :destroy, :exec => :project_unapproved_and_user_not_site_admin?, :redirect_to => :projects
  deny :show, :edit, :update, :destroy, :exec => :project_private_and_user_not_member?, :redirect_to => :projects
  
  allow :new, :create, :user => :is_registered_user?
  allow :edit, :update, :user => :is_project_administrator_for?, :redirect_to => :project
  allow :destroy, :user => :is_site_admin?, :redirect_to => :project

  def index
    @tags = Project.tag_counts
    @levels = (1 .. 5).map { |i| "level-#{i}" }
    
    if params[:show_search_form]
      @advanced_search = false
      search_params = { "order_by" => "name", "order_as" => "ASC" }
      search_params.merge!(params[:search]) if params[:search]
      search_params.delete("conditions")
      
      if current_user.is_site_admin?
        @search = Project.new_search(search_params)
      else
        @search = Project.approved.public.new_search(search_params)
      end

      if params[:search]
        @search.conditions.any = true
        
        if params[:advanced_search]
          @advanced_search = true
          @search.conditions.name_kw_using_or = params[:search][:conditions][:name_kw_using_or]
          @search.conditions.shortname_kw_using_or = params[:search][:conditions][:shortname_kw_using_or]
          @search.conditions.description_kw_using_or = params[:search][:conditions][:description_kw_using_or]
          @search.conditions.tags.name_kw_using_or = params[:search][:conditions][:tags][:name_kw_using_or]
          @search.conditions.project_status_id = params[:search][:conditions][:project_status_id]
          @search.conditions.project_maturity_id = params[:search][:conditions][:project_maturity_id]
          @search.conditions.project_category_id = params[:search][:conditions][:project_category_id]
        else
          @keywords = @search.conditions.name_kw_using_or = @search.conditions.shortname_kw_using_or = \
           @search.conditions.description_kw_using_or = @search.conditions.tags.name_kw_using_or = params[:keywords]
        end  
      end
      
      # The user clicked on a tag item link either on project show or projects index.
      if params[:tag]
        @advanced_search = true
        @search.conditions.tags.name_kw_using_or = params[:tag]
      end  

      @projects, @projects_count = @search.all, @search.count
    else
      @projects = current_user.is_site_admin? ? Project.all : Project.public.approved
    end        
    
    respond_to do |format|
      format.html { params[:show_search_form] ? render(:action => 'filtered_index') : render(:action => 'index') }
      format.xml  { render :xml => @projects }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @project }
    end
  end

  def new
    @project = Project.new
    @project.issue_tracker = IssueTracker.new(:use_internal => true)
    @project.repository = Repository.new(:use_internal => true)
    @project.web_dav_location = WebDavLocation.new(:use_internal => true)
    @project.forum = Forum.new(:use_internal => true)
    @project.wiki = Wiki.new(:use_internal => true)

    set_display_external_urls

    respond_to do |format|
      format.html
      format.xml  { render :xml => @project }
    end
  end
  
  def validate_proj_sname
    if params[:proj_sname] && params[:proj_sname].length > 0
      if (params[:proj_sname] =~ /\A([A-Z]+)\Z/)==nil
        render :text=>"<font color='red'><b>Invalid Project Short Name</b></font>"
      elsif Project.exists?(:shortname=>params[:proj_sname])
        render :text=>"<font color='red'><b>Invalid Project Short Name - Project Short Name already taken</b></font>"
      else
        render :text=>"<font color='blue'><b>Valid Project Short Name</b></font>"
      end
    else
       render :text=>""
    end
  end

  def create
    @project = Project.new(params[:project])
    @project.issue_tracker = IssueTracker.new(params[:issue_tracker])
    @project.repository = Repository.new(params[:repository])
    @project.web_dav_location = WebDavLocation.new(params[:web_dav_location])
    @project.forum = Forum.new(params[:forum])
    @project.wiki = Wiki.new(params[:wiki])

    set_display_external_urls
    
    respond_to do |format|
      if @project.issue_tracker.valid? and @project.repository.valid? and @project.web_dav_location.valid? and @project.forum.valid? and \
       @project.wiki.valid? and @project.save
        flash[:notice] = 'Your request to create a new project was sent to the site administrator.'
        format.html { redirect_to :controller => 'homepage' }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    set_display_external_urls
  end
  
  def update
    @project.issue_tracker.update_attributes(params[:issue_tracker])
    @project.repository.update_attributes(params[:repository])
    @project.web_dav_location.update_attributes(params[:web_dav_location])
    @project.forum.update_attributes(params[:forum])
    @project.wiki.update_attributes(params[:wiki])

    set_display_external_urls
    
    respond_to do |format|
      if @project.update_attributes(params[:project]) and @project.issue_tracker.valid? and @project.repository.valid? and \
       @project.web_dav_location.valid? and @project.forum.valid? and @project.wiki.valid?
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_project
    @project = params[:shortname] ? Project.find_by_shortname(params[:shortname]) : Project.find(params[:id])
  end  
  
  def project_unapproved_and_user_not_site_admin?
    not @project.approved? and not current_user.is_site_admin?
  end
  
  def project_private_and_user_not_member?
    @project.is_private? and not current_user.is_project_member_for?(@project)
  end  
  
  def set_display_external_urls
    @display_issue_tracker_external_url = @project.issue_tracker.use_internal? ? 'none' : 'block'
    @display_repository_external_url = @project.repository.use_internal? ? 'none' : 'block'
    @display_web_dav_location_external_url = @project.web_dav_location.use_internal? ? 'none' : 'block'
    @display_forum_external_url = @project.forum.use_internal? ? 'none' : 'block'
    @display_wiki_external_url = @project.wiki.use_internal? ? 'none' : 'block'
  end

  def get_terms_and_conditions_text
    @terms_and_conditions_text = File.read("#{RAILS_ROOT}/public/legal.html")
  rescue
    @terms_and_conditions_text = ''
  end
end
