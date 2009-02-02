class WikiPageAttachmentDownload < ActiveRecord::Base
  belongs_to :wiki_page_attachment
  belongs_to :downloaded_by, :class_name => "User", :foreign_key => "downloaded_by_id"
end
