#
# MailManager handles the Project Mailing Lists
#
class MailingList < ActiveRecord::Base
  belongs_to :project
  
  validates_presence_of :name
  validates_associated :project

  def post_address
    use_internal? ? internal_post_address : external_post_address
  end  

  def subscribe_address
    use_internal? ? internal_subscribe_address : external_subscribe_address
  end  
  
  def unsubscribe_address
    use_internal? ? internal_unsubscribe_address : external_unsubscribe_address
  end  
  
  def internal_post_address
    "#{full_name}@#{MAILING_LIST_DOMAIN}"
  end  

  def internal_subscribe_address
    "#{full_name}-subscribe@#{MAILING_LIST_DOMAIN}"
  end  
  
  def internal_unsubscribe_address
    "#{full_name}-unsubscribe@#{MAILING_LIST_DOMAIN}"
  end  
  
  def create_internal
    return true if not use_internal?

    # if SVN_DAV_HOST[:ssh] is nil, then commands are run locally 
    CommandExecutor.open(SVN_DAV_HOST[:ssh]) { |x|
    
      # Only create the list if it does not exist
      if !x.dir_exists?("/var/lib/mailman/lists/#{full_name}/config.pck")
        x.system("""newlist '#{full_name}' '#{admin_email}' '#{generate_passwd}' 1<<EOF\n\nEOF""", "list")==0  or raise "newlist command failed";
      end
      
      x.write(list_configuration, "/tmp/#{full_name}.cfg")
      x.system("config_list -i /tmp/#{full_name}.cfg #{full_name}", "list")==0  or raise "Could not configure mailing list:\n #{x.output}";
    }
    true
    
  rescue => error
    logger.error """Error creating the mailing list: #{error}\n#{error.backtrace.join("\n")}"""
  end
  
  private 
  
  def full_name
    "#{project.key}-#{name}"
  end
  
  def admin_email
    "#{project.key}-#{name}"
  end
    
  def generate_passwd(length=10)
    chars = ("A".."Z").to_a + ("a".."z").to_a + ("1".."9").to_a 
    return Array.new(length, '').collect{chars[rand(chars.size)]}.join
  end
    
  def list_configuration
    rc = """
      real_name = '#{full_name}'
      description = '#{project.name} #{name} mailing list'
      host_name = '#{MAILING_LIST_DOMAIN}'
      subject_prefix = ''
      respond_to_post_requests = 0
      max_message_size = 1024
      msg_footer = ''
      advertised = 0
      subscribe_policy = 1
      """
    if internal_replyto.blank?
      rc += """
        reply_goes_to_list = 1
        reply_to_address = ''
        """
    else
      rc += """
        reply_goes_to_list = 1
        reply_to_address = ''
        """
    end
    return rc
  end

end