class UnapprovedProjectsController < ApplicationController
  #rescue_from 'SOAP::FaultError', :with => :handle_soap_error
  
  before_filter :get_unapproved_project, :only => [:show, :update, :destroy]
  
  allow :user => :is_site_admin?
  
  # GET /unapproved_projects
  # GET /unapproved_projects.xml
  def index
    @unapproved_projects = Project.unapproved
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @unapproved_projects }
    end
  end

  # GET /unapproved_projects/1
  # GET /unapproved_projects/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @unapproved_project }
    end
  end

  # PUT /unapproved_projects/1
  # PUT /unapproved_projects/1.xml
  def update
    respond_to do |format|
      if @unapproved_project.approve
        flash[:notice] = 'Project has been approved.'
        format.html { redirect_to(unapproved_projects_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @unapproved_project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @unapproved_project.destroy

    respond_to do |format|
      format.html { redirect_to(unapproved_projects_path) }
      format.xml  { head :ok }
    end
  end

  private
  
  def get_unapproved_project
    @unapproved_project = Project.find_unapproved_by_id(params[:id])
  end  
  
end
