

class ProjectAdminGroupsController < BaseProjectsController
  before_filter :get_project
  before_filter :get_project_admin_group, :only => [:show, :destroy]

  allow :index, :show, :new, :create, :destroy, :exec => :user_is_administrator_for_project_and_company_employee?, 
   :redirect_to => :homepage

  def index
    @project_admin_groups = @project.admin_groups

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @project_admin_groups }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_admin_group }
    end
  end

  def new
    @project_admin_group = ProjectAdminGroup.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_admin_group }
    end
  end

  def create
    @project_admin_group = ProjectAdminGroup.new(params[:project_admin_group])
    @project_admin_group.project = @project

    respond_to do |format|
      if @project_admin_group.save
        @project.deploy
        
        flash[:notice] = 'Project Admin Group was successfully added.'
        format.html { redirect_to(project_project_admin_group_path(:project_id => @project.id, :id => @project_admin_group.id)) }
        format.xml  { render :xml => @project_admin_group, :status => :created, :location => @project_admin_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_admin_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project_admin_group.destroy
    @project.deploy
    respond_to do |format|
      format.html { redirect_to(project_project_admin_groups_path(:project_id => @project.id)) }
      format.xml  { head :ok }
    end
  end

  private

  def get_project_admin_group
    @project_admin_group = @project.admin_groups.find(params[:id])
  end    
end
