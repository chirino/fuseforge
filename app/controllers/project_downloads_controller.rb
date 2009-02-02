class ProjectDownloadsController < ApplicationController
  before_filter :get_project

  allow :user => :is_project_administrator_for?, :object => :project, :redirect_to => '/'

  def index
    @downloads = @project.downloads.sort { |a,b| b.created_at <=> a.created_at }

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @downloads }
    end
  end

  private
  
  def get_project
    @project = Project.find(params[:project_id])
  end
end
