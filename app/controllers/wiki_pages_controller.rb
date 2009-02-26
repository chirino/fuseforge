class WikiPagesController < ApplicationController
	skip_before_filter :login_required, :only => [:index, :show]

  before_filter :get_project
  before_filter :get_wiki_page, :only => [:show, :edit, :update, :destroy]
  
  deny :index, :show, :exec => :project_private_and_user_not_member?, :redirect_to => root_path

  allow :new, :create, :edit, :update, :destroy, :user => :is_project_member_for?, :object => :project, :redirect_to => root_path

  def index
    @tags = @project.wiki.wiki_pages.tag_counts
    @levels = (1 .. 5).map { |i| "level-#{i}" }
    
    default_search_params = { "order_by" => "slug", "order_as" => "ASC" }
    search_params = params[:search].blank? ? default_search_params : default_search_params.merge(params[:search])
    @search = @project.wiki.wiki_pages.new_search(search_params)
    @search.conditions.tags.name_kw_using_or = params[:tag] if params[:tag]
    @wiki_pages, @wiki_pages_count = @search.all, @search.count
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wiki_pages }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @wiki_page }
    end
  end

  def new
    @wiki_page = WikiPage.new
    @wiki_page.slug = params[:slug]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @wiki_page }
    end
  end

  def create
    @wiki_page = WikiPage.new(params[:wiki_page])
    @wiki_page.wiki = @project.wiki

    respond_to do |format|
      if @wiki_page.save
        format.html { redirect_to project_wiki_page_path(:project_id => @project.id, :id => @wiki_page.id) }
        format.xml  { render :xml => @wiki_page, :status => :created, :location => @wiki_page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @wiki_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @wiki_page.update_attributes(params[:wiki_page])
        format.html { redirect_to project_wiki_page_path(:project_id => @project.id, :id => @wiki_page.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wiki_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @wiki_page.destroy

    respond_to do |format|
      format.html { redirect_to(project_wiki_pages_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_project
    @project = Project.find(params[:project_id])
  end
  
  def get_wiki_page
    @wiki_page = @project.wiki.wiki_pages.find(params[:id])
  end    

  def project_private_and_user_not_member?
    @project.is_private? and not current_user.is_project_member_for?(@project)
  end  
end
