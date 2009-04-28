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
    "#{project.key}-#{name}@#{MAILING_LIST_DOMAIN}"
  end  

  def internal_subscribe_address
    "#{project.key}-#{name}-subscribe@#{MAILING_LIST_DOMAIN}"
  end  
  
  def internal_unsubscribe_address
    "#{project.key}-#{name}-unsubscribe@#{MAILING_LIST_DOMAIN}"
  end  
  

end