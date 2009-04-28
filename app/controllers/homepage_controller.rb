class HomepageController < ApplicationController
	skip_before_filter :login_required

  def index
    @featured_projects = FeaturedProject.projects
    @my_projects = logged_in? ? current_user.projects : []
    respond_to do |format|
      format.html { render :layout=>"new_look" }
    end
  end
end
