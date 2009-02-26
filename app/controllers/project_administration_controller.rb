class ProjectAdministrationController < ApplicationController
  before_filter :get_project

  allow :user => :is_project_administrator_for?, :object => :project, :redirect_to => :homepage

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  private
  
  def get_project
    @project = Project.find(params[:id])
  end
end