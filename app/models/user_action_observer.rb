class UserActionObserver < ActiveRecord::Observer
  observe ProjectNewsItem, NewsItem, FeaturedProject, ProjectGroup

  cattr_accessor :current_user

  def before_create(model)
    model.created_by = @@current_user
  end

  def before_save(model)
    model.updated_by = @@current_user
  end
end
