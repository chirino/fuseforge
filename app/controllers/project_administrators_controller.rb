class ProjectAdministratorsController < ApplicationController
  before_filter :get_project
  before_filter :get_project_administrator, :only => [:show, :destroy]
  
  allow :create, :destroy, :user => :is_project_administrator_for?, :object => :project, :redirect_to => :homepage
  
  def index
    @project_administrators = @project.default_administrators
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_administrators }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_administrator }
    end
  end

  def create
    flash[:error] = nil
    @login = params[:login]
    
    if @login.blank?
      flash[:error] = 'You must enter a user login!'
    else  
      if user = User.find_or_create_by_crowd_login(@login)
        if @project.administrators.include?(user)
          flash[:error] = "#{user.full_name} is already a project administrator!"
        else
          @project.add_administrator(user)
          flash[:notice] = "#{user.full_name} has been made a project administrator."  
        end
      else
        flash[:error] = "#{@login} is not a valid user login!"
      end
    end  

    respond_to do |format|
      if flash[:error].blank?
        format.html { redirect_to(project_project_administrators_path(@project)) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def destroy
    @project.remove_administrator(@project_administrator)
    
    respond_to do |format|
      format.html { redirect_to(project_project_admins_path(@project)) }
      format.xml  { head :ok }
    end
  end

  private
  
  def get_project
    @project = Project.find(params[:project_id])
  end
  
  def get_project_administrator
    @project_administrator = @project.find_administrator_by_user_id(params[:id])
  end  
end
