module CrowdGroupMixins
  def add_crowd_user(login)
    Crowd.new.add_user_to_group(login, self.name)
  end  
  
  def remove_crowd_user(login)
    Crowd.new.remove_user_from_group(login, self.name)
  end  
  
  def user_names
    Crowd.new.find_users_in_group(self.name)
  end   
  
  def users
    Crowd.new.find_users_in_group(self.name).collect { |u| User.find_or_create_by_login(u) }.compact
  end
end
