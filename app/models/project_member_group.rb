class ProjectMemberGroup < ProjectGroup
  def default?
    self == self.project.member_groups.default
  end

  def add_user(user)
    return unless self.default?
    super
  end  
  
  def remove_user(user)
    return unless self.default?
    super
  end  
end
