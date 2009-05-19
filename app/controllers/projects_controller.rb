class ProjectsController < ApplicationController
  layout "new_look"
	skip_before_filter :login_required, :only => [:index, :show, :source, :has_git_access]

  before_filter :get_project, :only => [:show, :source, :edit, :update, :destroy, :has_git_access]
  before_filter :get_terms_and_conditions_text, :only => [:new, :create]
  
  deny :show, :source, :edit, :update, :destroy, :exec => :project_unapproved_and_user_not_site_admin?, :method => :access_denied
  deny :show, :source, :edit, :update, :destroy, :exec => :project_private_and_user_not_member?, :method => :access_denied

  allow :create, :exec => :can_create?, :method => :access_denied
  allow :edit, :update, :user => :is_project_administrator_for?, :method => :access_denied
  allow :destroy, :user => :is_site_admin?, :method => :access_denied

  protect_from_forgery :except => [:validate_proj_sname]

  def index
    @tags = Project.tag_counts
    @levels = (1 .. 5).map { |i| "level-#{i}" }
    
    @advanced_search = false
    search_params = { "order_by" => "name", "order_as" => "ASC" }
    search_params.merge!(params[:search]) if params[:search]
    search_params.delete("conditions")
    
    if current_user.is_site_admin?
      if params[:advanced_search]
        @search = Project.new_search(search_params)
      else
        @search = Project.active.new_search(search_params)
      end
    else
      @search = Project.active.visibile_to(current_user).new_search(search_params)
    end

    @search.conditions.any = false
    if params[:search]
      if params[:advanced_search]
        @advanced_search = true
        @search.conditions.name_kw_using_or = params[:search][:conditions][:name_kw_using_or]
        @search.conditions.shortname_kw_using_or = params[:search][:conditions][:shortname_kw_using_or]
        @search.conditions.description_kw_using_or = params[:search][:conditions][:description_kw_using_or]
        @search.conditions.tags.name_kw_using_or = params[:search][:conditions][:tags][:name_kw_using_or]
        @search.conditions.project_status_id = params[:search][:conditions][:project_status_id] unless params[:search][:conditions][:project_status_id].empty?
        @search.conditions.project_maturity_id = params[:search][:conditions][:project_maturity_id] unless params[:search][:conditions][:project_maturity_id].empty?
        @search.conditions.project_category_id = params[:search][:conditions][:project_category_id] unless params[:search][:conditions][:project_category_id].empty?
      else
        @search.conditions.any = true
        @keywords = \
          @search.conditions.name_kw_using_or = \
          @search.conditions.shortname_kw_using_or = \
          @search.conditions.description_kw_using_or = \
          @search.conditions.tags.name_kw_using_or = \
          params[:keywords]
      end  
    end

    # The user clicked on a tag item link either on project show or projects index.
    if params[:tag]
      @advanced_search = true
      @search.conditions.tags.name_kw_using_or = params[:tag]
    end  
    if params[:category]
      @advanced_search = true
      @search.conditions.project_category_id = params[:category]
    end  

    @projects = @search.all
    @projects_count = @search.count
    
    @search.conditions.project_status_id = ProjectStatus.active.id.to_s unless params[:advanced_search]
    @search.conditions.name_kw_using_or = \
      @search.conditions.shortname_kw_using_or = \
      @search.conditions.description_kw_using_or = \
      @search.conditions.tags.name_kw_using_or = \
      "" unless params[:advanced_search]
      
    respond_to do |format|
      format.html
      format.xml  { render :xml => @projects }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @project }
    end
  end

  def source
    respond_to do |format|
      format.html
    end
  end

  def new
    if( can_create? )
      @project = Project.new
      @project.issue_tracker = IssueTracker.new(:use_internal => false)
      @project.repository = Repository.new(:use_internal => false)
      @project.git_repo = GitRepo.new(:use_internal => false)
      @project.web_dav_location = WebDavLocation.new(:use_internal => false)
      @project.forum = Forum.new(:use_internal => false)
      @project.wiki = Wiki.new(:use_internal => false)

      set_display_external_urls
      set_display_other_license_url

      respond_to do |format|
        format.html
        format.xml  { render :xml => @project }
      end
    else
      respond_to do |format|
 	      format.html { redirect_to icla_path } 
        format.xml  { render :status => 401 }
      end
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
    @project.git_repo = GitRepo.new(params[:git_repo])
    @project.web_dav_location = WebDavLocation.new(params[:web_dav_location])
    @project.forum = Forum.new(params[:forum])
    @project.wiki = Wiki.new(params[:wiki])

    set_display_external_urls
    set_display_other_license_url
    
    respond_to do |format|
      if @project.issue_tracker.valid? and \
         @project.repository.valid? and \
         @project.git_repo.valid? and \
         @project.web_dav_location.valid? and \
         @project.forum.valid? and \
         @project.wiki.valid? and \
         @project.save
       
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
    set_display_other_license_url
    
    respond_to do |format|
      format.html { render :layout => "new_look" }
    end
  end
  
  def update
    @project.issue_tracker.update_attributes(params[:issue_tracker])
    @project.repository.update_attributes(params[:repository])
    @project.git_repo.update_attributes(params[:git_repo])
    @project.web_dav_location.update_attributes(params[:web_dav_location])
    @project.forum.update_attributes(params[:forum])
    @project.wiki.update_attributes(params[:wiki])

    set_display_external_urls
    set_display_other_license_url
    
    respond_to do |format|
      if @project.update_attributes(params[:project]) and \
         @project.issue_tracker.valid? and \
         @project.repository.valid? and \
         @project.git_repo.valid? and \
         @project.web_dav_location.valid? and \
         @project.forum.valid? and \
         @project.wiki.valid?
         
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to project_administration_path(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit"}
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.inactivate
    flash[:notice] = 'Project has been inactivated.'

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
  
  def has_git_access
    rc = false
    
    if @project.git_repo.use_internal?
      user = User.find_by_login(params[:user])
      if user && user.is_project_member_for?(@project)
        rc=true;
      end
    end
    
    respond_to do |format|
      format.html { render :text => "#{rc}" }
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

  def can_create?
    current_user.is_icla_on_file? || current_user.is_company_employee?
  end  
  
  def set_display_external_urls
    @display_issue_tracker_external_url = @project.issue_tracker.use_internal? ? 'none' : 'block'
    @display_repository_external_url = @project.repository.use_internal? ? 'none' : 'block'
    @display_git_repo_external_url = @project.git_repo.use_internal? ? 'none' : 'block'
    @display_web_dav_location_external_url = @project.web_dav_location.use_internal? ? 'none' : 'block'
    @display_forum_external_url = @project.forum.use_internal? ? 'none' : 'block'
    @display_wiki_external_url = @project.wiki.use_internal? ? 'none' : 'block'
  end
  
  def set_display_other_license_url
    @display_other_license_url = (not @project.license.blank?) && (@project.license.name == 'Other') ? 'block' : 'none'
  end

  def get_terms_and_conditions_text
    @terms_and_conditions_text = File.read("#{RAILS_ROOT}/public/legal.html")
  rescue
    @terms_and_conditions_text = ''
  end
end
