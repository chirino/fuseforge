require 'confluence_lib/confluence_interface.rb'
class UnapprovedProjectsController < ApplicationController
  #rescue_from 'SOAP::FaultError', :with => :handle_soap_error
  
  before_filter :get_unapproved_project, :only => [:show, :update, :destroy]
  
  allow :user => :is_site_admin?, :redirect_to => '/'
  
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
      begin
        approved = @unapproved_project.approve
      rescue SOAP::FaultError => e
        if e.to_s.include?('no group found for that groupName')
          flash[:error] = 'Waiting for groups to migrate to Jira.  Please try again in a few minutes.'
        else
          flash[:error] = e.to_s
        end
      end
        
      if approved
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
  
#  def handle_soap_error(exception)
#    case exception.to_s
#    when /no group found for that groupName/
#      flash[:error] = "The project was not approved because one of it's Crowd groups does not exist in Jira."
#      redirect_to :action => :index
#    else
#      flash[:error] = "There was a SOAP error."
#      logger.error exception.to_s
#      redirect_to :action => :index
#    end
#  end
end
