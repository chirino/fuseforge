class WikiPageAttachmentsController < ApplicationController
  before_filter :get_project
  before_filter :get_wiki_page
  before_filter :get_wiki_page_attachment, :only => [:show, :edit, :update, :destroy]

  allow :new, :create, :edit, :update, :destroy, :show, :user => :is_project_member_for?, :object => :project, :redirect_to => :homepage

  def index
    @wiki_page_attachments = @wiki_page.attachments

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @wiki_page_attachments }
    end
  end

  def show
    send_file(@wiki_page_attachment.attached_file.path)
  end

  def new
    @wiki_page_attachment = WikiPageAttachment.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @wiki_page_attachment }
    end
  end

  def create
    @wiki_page_attachment = WikiPageAttachment.new(params[:wiki_page_attachment])
    @wiki_page_attachment.attached_file_file_name.gsub!(' ', '_')
    @wiki_page_attachment.wiki_page = @wiki_page

    respond_to do |format|
      if @wiki_page_attachment.save
        flash[:notice] = 'Wiki Page Attachment was successfully created.'
        format.html { redirect_to(project_wiki_page_wiki_page_attachments_path(:project_id => @project.id, :wiki_page_id => @wiki_page.id)) }
        format.xml  { render :xml => @wiki_page_attachment, :status => :created, :location => @wiki_page_attachment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @wiki_page_attachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @wiki_page_attachment.attached_file_file_name.gsub!(' ', '_')

    respond_to do |format|
      if @wiki_page_attachment.update_attributes(params[:wiki_page_attachment])
        flash[:notice] = 'Wiki Page Attachment was successfully updated.'
        format.html { redirect_to(project_wiki_page_wiki_page_attachments_path(:project_id => @project.id, :wiki_page_id => @wiki_page.id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wiki_page_attachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @wiki_page_attachment.destroy

    respond_to do |format|
      format.html { redirect_to(project_wiki_page_wiki_page_attachments_path(:project_id => @project.id, :wiki_page_id => @wiki_page.id)) }
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
  
  def get_wiki_page_attachment
    @wiki_page_attachment = @wiki_page.attachments.find(params[:id])
  end    
end
