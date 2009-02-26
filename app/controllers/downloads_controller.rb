class DownloadsController < ApplicationController
  skip_before_filter :login_required, :only => [:index, :show]
  
  before_filter :get_project
  before_filter :get_download, :only => [:show, :edit, :update, :destroy]

  deny :index, :show, :exec => :project_private_and_user_not_member?, :redirect_to => root_path
  allow :new, :create, :edit, :update, :destroy, :user => :is_project_administrator_for?, :object => :project, :redirect_to => root_path

  def index
    @downloads = @project.downloads.sort { |a,b| b.created_at <=> a.created_at }

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @downloads }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @download }
    end
  end

  def new
    @download = Download.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @download }
    end
  end

  def create
    @download = Download.new(params[:download])
    @download.project = @project

    respond_to do |format|
      if @download.save
        flash[:notice] = 'Download was successfully created.'
        format.html { redirect_to project_downloads_path(@project.id) }
        format.xml  { render :xml => @download, :status => :created, :location => @download }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @download.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @download.update_attributes(params[:download])
        flash[:notice] = 'Download was successfully updated.'
        format.html { redirect_to(project_download_path(:project_id => @project.id, :id => @download.id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_news_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @download.destroy

    respond_to do |format|
      format.html { redirect_to(project_downloads_path(:project_id => @project.id)) }
      format.xml  { head :ok }
    end
  end

  private
  
  def get_project
    @project = Project.find(params[:project_id])
  end
  
  def get_download
    @download = @project.downloads.find(params[:id])
  end    

  def project_private_and_user_not_member?
    @project.is_private? and not current_user.is_project_member_for?(@project)
  end  
end
