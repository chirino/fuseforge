class WikiPageAttachment < ActiveRecord::Base
  belongs_to :wiki_page
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
  
  has_many :downloads, :class_name => "WikiPageAttachmentDownload", :foreign_key => "wiki_page_attachment_id", :dependent => :destroy
  
  named_scope :include_in_project_homepage_download_stats, :conditions => { :include_in_project_homepage_download_stats => true }

  has_attached_file :attached_file, 
#    :url => "/:class/:id/:attachment/:style.:extension",
#    :path => ":rails_root/assets/:class/:attachment/:id/:style_:basename.:extension",      
    :default_url => "/:class/:attachment/missing_:style.png",
    :styles => { :thumb => "70x70" }
    
  
  validates_uniqueness_of :attached_file_file_name, :scope => :wiki_page_id  
end
