class WikiPageTagsController < ApplicationController
  before_filter :get_project
  before_filter :get_wiki_page
  
  allow :create, :user => :is_project_member_for?, :object => :project, :redirect_to => :wiki_page
  allow :index, :destroy, :user => :is_project_administrator_for?, :object => :project, :redirect_to => :wiki_page
  
  def create
    @wiki_page.tag_list.add(params[:tag])
    
    respond_to do |format|
      if @wiki_page.save
        flash[:notice] = 'Tag added'
      else
        flash[:notice] = 'Tag not added'
      end
      format.js {
        render :update do |page|
          page.replace 'wiki-page-tags', :partial => 'wiki_pages/tags'
        end  
      }
      format.html { redirect_to project_wiki_page_path(:project_id => @project.id, :wiki_page_id => @wiki_page.id) }
    end
  end

  def destroy
    @wiki_page.tag_list.remove(params[:tag])
    respond_to do |format|
      format.html { redirect_to(project_wiki_page_wiki_page_tags_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_project
    @project = Project.find(params[:project_id])
  end  
  
  def get_wiki_page
    @wiki_page = @project.wiki.wiki_pages.find(params[:wiki_page_id])
  end    
end
