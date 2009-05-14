class HomepageController < ApplicationController
  layout "new_look"
	skip_before_filter :login_required

  def index
    @featured_projects = FeaturedProject.projects
    @my_projects = logged_in? ? current_user.projects : []
    respond_to do |format|
      format.html
      format.xml  { render :xml =>{:my_project=>@my_projects, :featured_projects=>@featured_projects} }
    end
  end
end
