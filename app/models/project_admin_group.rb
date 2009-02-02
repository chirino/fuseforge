class ProjectAdminGroup < ProjectGroup
  def default?
    self == self.project.admin_groups.default
  end
end
