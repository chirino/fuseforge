class ProjectLicensesController < ApplicationController
  before_filter :get_project_license, :only => [:show, :edit, :update, :destroy]

  allow :index, :show, :new, :create, :edit, :update, :destroy, :user => :is_site_admin?, :redirect_to => :homepage

  def index
    @project_licenses = ProjectLicense.find(:all, :order => :position)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_licenses }
    end
  end

  def update_positions
    params[:sortable_list].each_index do |i|
      item = ProjectLicense.find(params[:sortable_list][i])
      item.position = i
      item.save
    end
    @project_licenses = ProjectLicense.find(:all, :order => 'position')	

    flash.now[:notice] = 'Project licenses have been re-ordered.'
    
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
      format.xml  { render :xml => @project_license }
    end
  end

  def new
    @project_license = ProjectLicense.new
    @project_license.is_active = true

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_license }
    end
  end

  def create
    @project_license = ProjectLicense.new(params[:project_license])

    respond_to do |format|
      if @project_license.save
        flash[:notice] = 'Project license was successfully created.'
        format.html { redirect_to(@project_license) }
        format.xml  { render :xml => @project_license, :status => :created, :location => @project_license }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_license.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_license.update_attributes(params[:project_license])
        flash[:notice] = 'Project license was successfully updated.'
        format.html { redirect_to(@project_license) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_license.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project_license.destroy

    respond_to do |format|
      format.html { redirect_to(project_licenses_url) }
      format.xml  { head :ok }
    end
  end
end

private

def get_project_license
  @project_license = ProjectLicense.find(params[:id])
end