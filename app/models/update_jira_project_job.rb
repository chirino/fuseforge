class UpdateJiraProjectJob < Struct.new(:shortname, :reset_to_private)
  def perform
    JiraInterface.new.update_project(shortname, reset_to_private)
  end
end