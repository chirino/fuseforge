class CrowdGroup
  include CrowdGroupMixins
  
  attr_reader :name
  
  def self.non_forge_group_names
    Crowd.new.find_all_group_names.reject { |x| x =~ /^#{ProjectGroup::DEFAULT_PREFIX.downcase}-/ }
  end

  def add_user(user)
    add_crowd_user(user)
  end
  
  def remove_user(user)
    remove_crowd_user(user)
  end    
end
