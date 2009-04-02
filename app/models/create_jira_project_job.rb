class CreateJiraProjectJob < Struct.new(:name, :shortname, :description, :login, :url, :is_pri)
#class CreateJiraProjectJob < Struct.new(:project)
  def perform
    JiraInterface.new.create_proj_default_perm(name, shortname, description, login, url, is_pri)
#    JiraInterface.new.create_proj_default_perm(project)
  end
end  