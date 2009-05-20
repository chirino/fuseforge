class ProjectStatusesController < ApplicationController
  before_filter :get_project_status, :only => [:show, :edit, :update, :destroy]

  allow :index, :show, :new, :create, :edit, :update, :destroy, :user => :is_site_admin?

  def index
    @project_statuses = ProjectStatus.find(:all, :order => :position)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_statuses }
    end
  end

  def update_positions
    params[:sortable_list].each_index do |i|
      item = ProjectStatus.find(params[:sortable_list][i])
      item.position = i
      item.save
    end
    @project_statuses = ProjectStatus.find(:all, :order => 'position')	

    flash.now[:notice] = 'Project statuses have been re-ordered.'
    
    respond_to do |format|
      format.js {
        render :update do |page|
          page.replace 'flash', :partial => 'shared/flash_msg'
          page.visual_effect(:fade, 'notice', :duration => 5.0)
        end  
      }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_status }
    end
  end

  def new
    @project_status = ProjectStatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_status }
    end
  end

  def create
    @project_status = ProjectStatus.new(params[:project_status])

    respond_to do |format|
      if @project_status.save
        flash[:notice] = 'Project Status was successfully created.'
        format.html { redirect_to(@project_status) }
        format.xml  { render :xml => @project_status, :status => :created, :location => @project_status }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_status.update_attributes(params[:project_status])
        flash[:notice] = 'Project Status was successfully updated.'
        format.html { redirect_to(@project_status) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project_status.destroy

    respond_to do |format|
      format.html { redirect_to(project_statuses_url) }
      format.xml  { head :ok }
    end
  end
end

private

def get_project_status
  @project_status = ProjectStatus.find(params[:id])
end