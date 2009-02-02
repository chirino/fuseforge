class WikiPage < ActiveRecord::Base
  RECENT_LIMIT = 5

  if self.table_exists?
    acts_as_versioned do
      def self.included(base)
        base.belongs_to :wiki
        base.belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
        base.belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
      end
    end  
  end
  
  acts_as_taggable_on :tags
  
  belongs_to :wiki
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"
  
  has_many :attachments, :class_name => "WikiPageAttachment", :foreign_key => "wiki_page_id", :dependent => :destroy
  
  named_scope :recent, :order => 'updated_at desc', :limit => RECENT_LIMIT  
  named_scope :download, :conditions => { :slug => 'Downloads' }, :limit => 1
  
  validates_presence_of :slug, :body, :wiki
  validates_associated :wiki, :updated_by
  validates_associated :created_by, :on => :create
  
  validates_uniqueness_of :slug, :scope => :wiki_id

  def title
    slug
  end
  
  def html_body
    # Replace filename link references to the full url of attached files.
    output = self.body.gsub(/":(?!http)\S+/) do |element|
      attachment = self.attachments.find_by_attached_file_file_name(element.gsub(/"|:/, ''))
      attachment.blank? ? element : "\":#{attachment.attached_file.url} "
    end
    
    # Replace dynamic links to other pages with Textile links.
    output = output.gsub(/\[[\w _-]*?\](?![:\(\[])/) do |element| 
#    output = output.gsub(/\[[\w_-]*?\](?![:\(\[])/) do |element| 

      page = self.wiki.wiki_pages.find_or_initialize_by_slug(element.gsub(/[\[\]]/, '')) 
      if page.id 
        url = "/projects/#{self.wiki.project_id}/wiki_pages/#{page.id}"
      else 
        title = element.delete("]")
        title.delete!("[")
        element = element.gsub("]", "?]")
        url = "/projects/#{self.wiki.project_id}/wiki_pages/new?slug=#{title.gsub(' ', '%20')}"
      end
      "\"#{element}\":#{url}"
    end
    
    # Replace image tag references to the full url of attached files.
    output.gsub!(/\!(?!http).+\(|\!(?!http).+!/) do |element|
      attachment = self.attachments.find_by_attached_file_file_name(element.gsub(/\!/, '').gsub(/\(/, ''))
      attachment.blank? ? element : "!#{attachment.attached_file.url}!"
    end

    RedCloth.new(output).to_html
  end  

  def self.html_body(wiki_page)
    output = wiki_page.body.gsub(/\[[\w_-]*?\](?![:\(\[])/) do |element| 
      page = wiki_page.project.wiki_pages.find_or_initialize_by_slug(element.gsub(/[\[\]]/, '')) 
      if page.id 
        url = "/projects/#{wiki_page.wiki.project_id}/wiki_pages/#{page.id}"
      else 
        title = element.delete("]")
        title.delete!("[")
        element = element.gsub("]", "?]")
        url = ""
      end
      "\"#{element}\":#{url}"
    end
    RedCloth.new(output).to_html
  end  
end
