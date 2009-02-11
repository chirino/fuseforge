class Notifier < ActionMailer::Base
  def project_approval_notification(project)
    recipients "#{project.created_by.full_name} <#{project.created_by.email}>"
    from       FUSEFORGE_EMAIL_ADDRESS
    subject    "Your FUSE Forge project has been approved."
    body       :project => project
  end

  def project_creation_notification(project)
    recipients SiteAdminGroup.new.users.collect { |u| "#{u.full_name} <#{u.email}>" }
    from       FUSEFORGE_EMAIL_ADDRESS
    subject    "A new FUSE Forge project is awaiting approval."
    body       :project => project
  end
end
