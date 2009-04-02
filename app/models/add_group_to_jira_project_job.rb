class AddGroupToJiraProjectJob < Struct.new(:shortname, :crowd_group, :group_type)
  def perform
    JiraInterface.new.add_groups_to_project(shortname, crowd_group, group_type)
  end
end