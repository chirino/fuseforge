module ProjectMemberGroupsHelper
  def options_for_select
    CrowdGroup.non_forge_group_names - @project.member_groups.group_names
  end
end
