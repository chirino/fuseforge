class FalseClass
  def is_registered_user?
    false
  end
    
  def is_project_administrator?
    false
  end
  
  def is_project_administrator_for?(project)
    false
  end  

  def is_project_member?
    false
  end
  
  def is_project_member_for?(project)
    false
  end  

  def is_site_admin?
    false
  end
end