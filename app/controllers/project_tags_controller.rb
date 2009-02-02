class ProjectTagsController < ApplicationController
  before_filter :get_project
  
  deny :create, :destroy, :exec => :project_unapproved?, :object => :project, :redirect_to => :project
  
  allow :create, :user => :is_project_member_for?, :object => :project, :redirect_to => :project
  allow :index, :destroy, :user => :is_project_administrator_for?, :object => :project, :redirect_to => :project
  
  def create
    @project.tag_list.add(params[:tag])
    
    respond_to do |format|
      flash[:notice] = @project.save ? 'Tag added' : 'Tag not added'
      format.js {
        render :update do |page|
          page.replace 'project_tags', :partial => 'projects/tags'
        end  
      }
      format.html { redirect_to(@project) }
    end
  end

  def destroy
    @project.tag_list.remove(params[:tag])
    respond_to do |format|
      format.html { redirect_to(project_tags_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_project
    @project = Project.find(params[:project_id])
  end  
  
  def project_unapproved?
    not @project.approved?
  end
end
