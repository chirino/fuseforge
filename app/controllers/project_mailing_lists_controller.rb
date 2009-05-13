class ProjectMailingListsController < ApplicationController
  skip_before_filter :login_required, :only => [:index]

  layout "new_look"
  before_filter :get_project
  before_filter :get_project_mailing_list, :only => [:show, :edit, :update, :destroy]

  deny :index, :show, :exec => :project_private_and_user_not_member?, :redirect_to => :homepage
  allow :new, :create, :edit, :update, :destroy, :reset_admin_password, :user => :is_project_administrator_for?, :object => :project, :redirect_to => :homepage

  def index
    @project_mailing_lists = @project.mailing_lists
    respond_to do |format|
      format.html { render :action => (params[:from_project_admin] ? 'admin_index' : 'index') }
      format.xml  { render :xml => @project_mailing_lists }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_mailing_list }
    end
  end

  def new
    @project_mailing_list = MailingList.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_mailing_list }
    end
  end

  def create
    @project_mailing_list = MailingList.new(params[:mailing_list])
    @project_mailing_list.project = @project

    respond_to do |format|
      begin
        if @project_mailing_list.save
          flash[:notice] = 'Mailing list was successfully created.'
          format.html { redirect_to(project_mailing_lists_path(:project_id => @project.id)) }
          format.xml  { render :xml => @project_mailing_list, :status => :created, :location => @project_mailing_list }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @project_mailing_list.errors, :status => :unprocessable_entity }
        end
      rescue => e
        flash[:error] = 'List could not be created.  Perhaps that list already exists.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_mailing_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_mailing_list.update_attributes(params[:mailing_list])
        flash[:notice] = 'Mailing list was successfully updated.'
        format.html { redirect_to(project_mailing_lists_path(:project_id => @project.id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_mailing_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project_mailing_list.destroy
    respond_to do |format|
      format.html { redirect_to(project_mailing_lists_path(:project_id => @project.id)) }
      format.xml  { head :ok }
    end
  end

  def reset_admin_password
    @project.mailing_lists.each do |ml|
      ml.reset_admin_password params[:password]
    end
    
    respond_to do |format|
      flash[:notice] = 'Mailing list passwords updated.'
      format.html { redirect_to(project_mailing_lists_path(:project_id => @project.id)) }
      format.xml  { head :ok }
    end
  end

  private
  
  def get_project
    @project = Project.find(params[:project_id])
  end
  
  def get_project_mailing_list
    @project_mailing_list = @project.mailing_lists.find(params[:id])
  end    

  def project_private_and_user_not_member?
    @project.is_private? and not current_user.is_project_member_for?(@project)
  end  
end
