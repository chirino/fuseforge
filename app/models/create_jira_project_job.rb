class CreateJiraProjectJob < Struct.new(:project)
  def perform
    JiraInterface.new.create_proj_default_perm(project)
  end
end  