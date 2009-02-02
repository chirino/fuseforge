class AttachedFilesController < ApplicationController
	skip_before_filter :login_required

  before_filter :get_wiki_page_attachment

  deny :show, :exec => :project_private_and_user_not_member?, :redirect_to => '/'

  def show
    @wiki_page_attachment.downloads << WikiPageAttachmentDownload.create
    
    send_file(@wiki_page_attachment.attached_file.path(params[:id]))
  end
  
  private
  
  def get_wiki_page_attachment
    @wiki_page_attachment = WikiPageAttachment.find(params[:wiki_page_attachment_id])
  end    
  
  def project_private_and_user_not_member?
    @wiki_page_attachment.wiki_page.wiki.project.is_private? and not \
     current_user.is_project_member_for?(@wiki_page_attachment.wiki_page.wiki.project)
  end  
end