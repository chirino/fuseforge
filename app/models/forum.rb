class Forum < ActiveRecord::Base
  INTERNAL_HOST = Socket.gethostname == 'dude' ? 'forge.fusesource.com' : 'fusesourcedev.com/forge'
  INTERNAL_PATH = '/phpBB3'
  INTERNAL_URL = 'http://' + INTERNAL_HOST + INTERNAL_PATH

  belongs_to :project
  belongs_to :phpbb_forum, :class_name => "PhpbbForum", :foreign_key => "phpbb_forum_id"
  
  def before_save
    self.external_url = '' if use_internal?
  end
  
  def before_destroy
    return true unless exists_internally?

    phpbb_forum.lock
    true
  end
  
  def use_internal=(value)
    bool_value = value == "1" ? true : false
    
    if (bool_value != read_attribute(:use_internal)) and not new_record?
      if bool_value
        create_internal
      else
        phpbb_forum.lock if exists_internally?
      end    
    end  
    
    write_attribute(:use_internal, value)
  end  
  
  def change_name(value)
    phpbb_forum.forum_name = value
    phpbb_forum.save
  end  
  
  def change_description(value)
    phpbb_forum.forum_desc = value
    phpbb_forum.save
  end  
  
  def is_active?
    use_internal? or not external_url.blank?
  end
  
  def internal_url
    "#{INTERNAL_URL}/viewforum.php?f=#{phpbb_forum.forum_id}&start=0"    
  end  
  
  def url
    use_internal? ? internal_url : external_url
  end
  
  def exists_internally?
    not phpbb_forum.blank?
  end  
  
  def create_internal
    if use_internal?
      if exists_internally?
        phpbb_forum.unlock
      else
        self.phpbb_forum = PhpbbForum.create(:forum_name => project.name, :forum_desc => project.description)
        save
        phpbb_forum.create_group_rights
      end
      purge_cache
    end  
  end
  
  def reset_permissions(make_private)
    return true if phpbb_forum.blank?
    
    phpbb_forum.recreate_group_rights(make_private)
    purge_cache
  end
  
  def purge_cache
    phpbb_forum.purge_cache
  end
  
  def recent_posts
    phpbb_forum.phpbb_posts.recent
  end  
end
