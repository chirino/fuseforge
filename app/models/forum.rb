#
# By default the Forum model only supports external forums
#
class Forum < ActiveRecord::Base
  belongs_to :project
  
  def before_save
    self.external_url = '' if use_internal?
  end
    
  def internal_supported?
    false
  end  

  def use_internal?
    false
  end  
  
  def is_active?
    use_internal? || !external_url.blank?
  end
  
  def internal_url
     nil
  end  
  
  def url
    use_internal? ? internal_url : external_url
  end

end

#
# If the phpbb database is configured, then update the Forum model 
# to allow internal phpbb3 forums.
#
if ActiveRecord::Base.configurations["phpbb"]

  class Forum 
  
    ActiveRecord::Base.belongs_to :phpbb_forum, :class_name => "PhpbbForum", :foreign_key => "phpbb_forum_id"
  
    def internal_supported?
      true
    end  

    def use_internal?
      read_attribute(:use_internal)
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

    def before_destroy
      return true unless exists_internally?
      phpbb_forum.lock
      true
    end
  
    def change_name(value)
      phpbb_forum.forum_name = value
      phpbb_forum.save
    end  
  
    def change_description(value)
      phpbb_forum.forum_desc = value
      phpbb_forum.save
    end  
  
    def internal_url
       use_internal? ? "#{FORGE_URL}/forum/viewforum.php?f=#{phpbb_forum.forum_id}&start=0" : nil
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
  
    def make_private
      reset_permissions(true)
    end
  
    def make_public
      reset_permissions(false)
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
  
end