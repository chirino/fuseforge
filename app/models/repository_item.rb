class RepositoryItem
  attr_reader :name, :url
  
  def initialize(project_repository)
    @project_repository = project_repository
    @name = "repo_item_source_code_name"
  end 

  def latest_version_url
#    @project_repository.url + "/#{@name}/trunk"
    'http://svn.techno-weenie.net/projects/plugins/attachment_fu/'
  end  
end