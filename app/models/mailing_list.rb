# ===========================================================================
# Copyright (C) 2009, Progress Software Corporation and/or its 
# subsidiaries or affiliates.  All rights reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ===========================================================================

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

    # if MAILMAN_CONFIG[:ssh] is nil, then commands are run locally 
    CommandExecutor.open(MAILMAN_CONFIG[:ssh]) { |x|
    
      # Only create the list if it does not exist
      if !x.file_exists?("/var/lib/mailman/lists/#{full_name}/config.pck")
        x.system("""newlist '#{full_name}' '#{admin_email}' '#{generate_passwd}' <<EOF\n\nEOF""", "list")==0  or raise "newlist command failed";
      end
      
      udpate_list_configuration(x)
    }
    true
    
  rescue => error
    logger.error """Error creating the mailing list: #{error}\n#{error.backtrace.join("\n")}"""
  end
  
  def reset_admin_password(passwd)
    return false if not use_internal?
    CommandExecutor.open(MAILMAN_CONFIG[:ssh]) do |x|
      # We update the list first so that the admin list is up to date.
      udpate_list_configuration(x)
      # Changing the password will email all the admins.
      x.system("/usr/lib/mailman/bin/change_pw -l #{full_name} -p '#{passwd}'", "list")==0
    end
  rescue => error
    logger.error """Error resetting the mailing list password: #{error}\n#{error.backtrace.join("\n")}"""
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
  
  def udpate_list_configuration(x)
    x.write(list_configuration, "/tmp/#{full_name}.cfg")
    x.system("config_list -i /tmp/#{full_name}.cfg #{full_name}", "list")==0  or raise "Could not configure mailing list:\n #{x.output}";
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
  
  def admin_emails
    rc = Set.new
    project.admin_groups.users.each do |x|
      if x.email && x.email =~ RFC822::EmailAddress
        rc << x.email
      end
    end
    rc.to_a
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
accept_these_nonmembers = ['^.*@#{domain}']
"""
    if internal_replyto.blank?
      rc << """
reply_goes_to_list = 1
reply_to_address = ''
"""
    else
      rc << """
reply_goes_to_list = 2
reply_to_address = '#{internal_replyto}'
"""
    end
    
    # Make all the admins the mailing list owners.
    rc << "owner = ["
    admin_emails.each_index do |i|
      rc << "," unless i==0
      rc << "'#{admin_emails[i]}'"
    end
    rc << "]\n"
    
    return rc
  end

end