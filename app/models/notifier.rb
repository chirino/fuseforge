class Notifier < ActionMailer::Base
  def project_approval_notification(project)
    recipients "#{project.created_by.full_name} <#{project.created_by.email}>"
    from       FUSEFORGE_EMAIL_ADDRESS
    subject    "Your FUSE Forge project, #{project.name}, has been approved."
    body       :project => project
  end

  def project_creation_notification(project)
    recipients CrowdGroup.forge_admin_group.users.collect { |u| "#{u.full_name} <#{u.email}>" }
    from       FUSEFORGE_EMAIL_ADDRESS
    subject    "A new FUSE Forge project, #{project.name}, is awaiting approval."
    body       :project => project
  end
end
