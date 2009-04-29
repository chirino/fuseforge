require 'command_executor'
require 'rfc822'

#
# MailManager handles the Project Mailing Lists
#
class MailingList < ActiveRecord::Base
  belongs_to :project
  
  validates_presence_of :name
  validates_associated :project

  validates_format_of :internal_replyto, {:with => RFC822::EmailAddress, :message=>'is an invalid email', :allow_nil=>true, :allow_blank=>true} 
  validates_format_of :external_post_address, {:with => RFC822::EmailAddress, :message=>'is an invalid email', :allow_nil=>true, :allow_blank=>true}
  validates_format_of :external_subscribe_address, {:with => RFC822::EmailAddress, :message=>'is an invalid email', :allow_nil=>true, :allow_blank=>true} 
  validates_format_of :external_unsubscribe_address, {:with => RFC822::EmailAddress, :message=>'is an invalid email', :allow_nil=>true, :allow_blank=>true}

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
    "#{full_name}@#{domain}"
  end  

  def internal_subscribe_address
    "#{full_name}-subscribe@#{domain}"
  end  
  
  def internal_unsubscribe_address
    "#{full_name}-unsubscribe@#{domain}"
  end 
  
  def create_internal
    return true if not use_internal?

    # if SVN_DAV_HOST[:ssh] is nil, then commands are run locally 
    CommandExecutor.open(MAILMAN_CONFIG[:ssh]) { |x|
    
      # Only create the list if it does not exist
      if !x.file_exists?("/var/lib/mailman/lists/#{full_name}/config.pck")
        x.system("""newlist '#{full_name}' '#{admin_email}' '#{generate_passwd}' <<EOF\n\nEOF""", "list")==0  or raise "newlist command failed";
      end
      
      x.write(list_configuration, "/tmp/#{full_name}.cfg")
      x.system("config_list -i /tmp/#{full_name}.cfg #{full_name}", "list")==0  or raise "Could not configure mailing list:\n #{x.output}";
    }
    true
    
  rescue => error
    logger.error """Error creating the mailing list: #{error}\n#{error.backtrace.join("\n")}"""
  end
  
  private
  
  def domain
    MAILMAN_CONFIG[:domain]
  end
  
  def full_name
    "#{project.key}-#{name}"
  end
  
  def management_url
    MAILMAN_CONFIG[:management_url]
  end
  
  def admin_email
    # Finds an admin email address that can be used as the list admin
    if project.created_by.email && project.created_by.email =~ RFC822::EmailAddress
      return project.created_by.email
    end
    project.admin_groups.users.each do |x|
      if x.email && x.email =~ RFC822::EmailAddress
        return x.email
      end
    end
    raise "No vaild admin email addresses available to be the owner of the mailing list"
  end
    
  def generate_passwd(length=10)
    chars = ("A".."Z").to_a + ("a".."z").to_a + ("1".."9").to_a 
    return Array.new(length, '').collect{chars[rand(chars.size)]}.join
  end
    
  def list_configuration
    rc = """
real_name = '#{full_name}'
description = '#{project.name} #{name} mailing list'
host_name = '#{domain}'
subject_prefix = ''
respond_to_post_requests = 0
max_message_size = 1024
msg_footer = ''
advertised = 0
subscribe_policy = #{project.is_private ? '3' : '1'}
web_page_url = '#{management_url}/'
accept_these_nonmembers = ['#{post_address}']
      """
    if internal_replyto.blank?
      rc += """
reply_goes_to_list = 1
reply_to_address = ''
        """
    else
      rc += """
reply_goes_to_list = 3
reply_to_address = '#{internal_replyto}'
        """
    end
    return rc
  end

end