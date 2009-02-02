class WikiPageVersionsController < ApplicationController
  before_filter :get_project
  before_filter :get_wiki_page
  before_filter :get_wiki_page_version, :only => [:show, :update]
  
  allow :user => :is_project_member_for?, :object => :project, :redirect_to => '/'

  def index
    @wiki_page_versions = @wiki_page.versions

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wiki_pages_versions }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @wiki_page_version }
    end
  end
  
  def update
    @wiki_page.revert_to!(@wiki_page_version)
    @wiki_page.updated_at = Time.now
    @wiki_page.save
    redirect_to project_wiki_page_wiki_page_versions_path(:project_id => @project.id, :wiki_page_id => @wiki_page.id)
  end

  private
  
  def get_project
    @project = Project.find(params[:project_id])
  end
  
  def get_wiki_page
    @wiki_page = @project.wiki.wiki_pages.find(params[:wiki_page_id])
  end    

  def get_wiki_page_version
    @wiki_page_version = @wiki_page.versions.find_by_version(params[:id])
  end
end
