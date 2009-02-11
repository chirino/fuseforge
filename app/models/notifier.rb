class Notifier < ActionMailer::Base
  def project_approval_notification(project)
    recipients "#{project.created_by.full_name} <#{project.created_by.email}>"
    from       FUSEFORGE_EMAIL_ADDRESS
    subject    "Your FUSE Forge project has been approved."
    body       :project => project
  end
end
