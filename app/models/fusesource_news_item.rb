class FusesourceNewsItem < ActiveRecord::Base
  establish_connection :radiant
  set_table_name 'news_items'
  
  named_scope :recent, :order => 'published_on desc', :limit => 5  

  def link_to_source
    if self.source_link =~ /^http:/
      self.source_link
    else
      "http://fusesource.com#{self.source_link}"
    end  
  end
end