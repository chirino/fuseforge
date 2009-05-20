###############################################################################
# NOTE:  This is not currently being used.
###############################################################################

class ProspectiveProjectMembersController < ApplicationController
  before_filter :get_project
  before_filter :get_prospective_project_member, :only => [:show, :update, :destroy]
  
  allow :create, :user => :is_registered_user?
  allow :index, :show, :update, :destroy, :user => :is_project_administrator_for?, :object => :project
  

  def index
    @prospective_project_members = @project.prospective_members

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @prospective_project_members }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @prospective_project_member }
    end
  end

  def new
    @prospective_project_member = ProspectiveProjectMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @prospective_project_member }
    end
  end

  def create
    @prospective_project_member = ProspectiveProjectMember.new(params[:prospective_project_member])
    @prospective_project_member.project = @project
    @prospective_project_member.user = current_user

    respond_to do |format|
      if @prospective_project_member.save
        flash[:notice] = 'Your request to be added as a project member has been created.'
        format.html { redirect_to(project_path(@project)) }
        format.xml  { render :xml => @prospective_project_member, :status => :created, :location => @prospective_project_member }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @prospective_project_member.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @prospective_project_member.accept
      flash[:notice] = 'Prospective member was accepted.'
      format.html { redirect_to(project_prospective_project_members_path(@project)) }
      format.xml  { head :ok }
    end
  end

  def destroy
    @prospective_project_member.deny

    respond_to do |format|
      format.html { redirect_to(project_prospective_project_members_path(@project)) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_project
    @project = Project.find(params[:project_id])
  end
  
  def get_prospective_project_member
    @prospective_project_member = @project.prospective_members.find(params[:id])
  end    
end
