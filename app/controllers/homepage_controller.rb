class HomepageController < ApplicationController
	skip_before_filter :login_required

  def index
    @featured_projects = FeaturedProject.projects
    @my_projects = logged_in? ? current_user.projects : []

    @fuseforge_news_items = FuseforgeNewsItem.recent
    @fusesource_news_items = FusesourceNewsItem.recent
    @most_active_projects = Project.most_active
    @top_project_downloads = Project.most_downloaded

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
