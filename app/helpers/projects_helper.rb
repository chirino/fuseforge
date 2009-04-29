module ProjectsHelper
  def search_select_options_for_project_status
    current_user.is_site_admin? ? ProjectStatus.options_for_select : ProjectStatus.options_for_select_approved
  end
  
  def truncate(text, length = 30, end_string = '...')
    return "" if text == nil
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end

  def category_cloud
    cats = ProjectCategory.all
    classes = @levels
    max_count = cats.sort_by(&:count).last.count.to_f
    cats.each do |cat|
      index = ((cat.count / max_count) * (classes.size - 1)).round
      yield cat, classes[index]
    end
  end

end


