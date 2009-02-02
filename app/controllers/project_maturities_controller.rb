class ProjectMaturitiesController < ApplicationController
  before_filter :get_project_maturity, :only => [:show, :edit, :update, :destroy]

  allow :index, :show, :new, :create, :edit, :update, :destroy, :user => :is_site_admin?, :redirect_to => '/'

  def index
    @project_maturities = ProjectMaturity.find(:all, :order => :position)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_maturities }
    end
  end

  def update_positions
    params[:sortable_list].each_index do |i|
      item = ProjectMaturity.find(params[:sortable_list][i])
      item.position = i
      item.save
    end
    @project_maturities = ProjectMaturity.find(:all, :order => 'position')	

    flash.now[:notice] = 'Project maturities have been re-ordered.'
    
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
      format.xml  { render :xml => @project_maturity }
    end
  end

  def new
    @project_maturity = ProjectMaturity.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_maturity }
    end
  end

  def create
    @project_maturity = ProjectMaturity.new(params[:project_maturity])

    respond_to do |format|
      if @project_maturity.save
        flash[:notice] = 'Project Maturity was successfully created.'
        format.html { redirect_to(@project_maturity) }
        format.xml  { render :xml => @project_maturity, :status => :created, :location => @project_maturity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_maturity.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_maturity.update_attributes(params[:project_maturity])
        flash[:notice] = 'Project Maturity was successfully updated.'
        format.html { redirect_to(@project_maturity) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_maturity.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project_maturity.destroy

    respond_to do |format|
      format.html { redirect_to(project_maturities_url) }
      format.xml  { head :ok }
    end
  end
end

private

def get_project_maturity
  @project_maturity = ProjectMaturity.find(params[:id])
end