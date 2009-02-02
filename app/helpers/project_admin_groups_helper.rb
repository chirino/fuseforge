module ProjectAdminGroupsHelper
  def options_for_select
    CrowdGroup.non_forge_group_names - @project.admin_groups.group_names
  end
end
