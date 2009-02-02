class Guest
  def is_guest?
    true
  end

  def method_missing(methId, *args)
    # This traps for any base_auth methods, like :is_site_admin? or :is_project_administrator_for?
    return false if methId.id2name =~ /^is_.+\?$/
    raise
  end
end