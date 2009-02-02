class WikiPageAttachmentDownloadObserver < ActiveRecord::Observer
  cattr_accessor :current_user

  def before_create(wiki_page_attachment_download)
    wiki_page_attachment_download.downloaded_by = @@current_user
  end
end
