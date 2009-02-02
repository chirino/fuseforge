module ProjectsHelper
  def search_select_options_for_project_status
    current_user.is_site_admin? ? ProjectStatus.options_for_select : ProjectStatus.options_for_select_approved
  end
end
