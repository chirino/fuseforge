class ProjectMemberGroupsController < BaseProjectsController
  before_filter :get_project
  before_filter :get_project_member_group, :only => [:show, :destroy]

  deny :index, :show, :exec => :project_private_and_user_not_member?, :redirect_to => root_path

  allow :new, :create, :destroy, :exec => :user_is_administrator_for_project_and_company_employee?, :redirect_to => root_path

  def index
    @project_member_groups = @project.member_groups

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @project_member_groups }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_member_group }
    end
  end

  def new
    @project_member_group = ProjectMemberGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_member_group }
    end
  end

  def create
    @project_member_group = ProjectMemberGroup.new(params[:project_member_group])
    @project_member_group.project = @project

    respond_to do |format|
      if @project_member_group.save
        flash[:notice] = 'Project Member Group was successfully added.'
        format.html { redirect_to(project_project_member_group_path(:project_id => @project.id, :id => @project_member_group.id)) }
        format.xml  { render :xml => @project_member_group, :status => :created, :location => @project_member_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_member_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project_member_group.destroy

    respond_to do |format|
      format.html { redirect_to(project_project_member_groups_path(:project_id => @project.id)) }
      format.xml  { head :ok }
    end
  end

  private

  def get_project_member_group
    @project_member_group = @project.member_groups.find(params[:id])
  end    
end
