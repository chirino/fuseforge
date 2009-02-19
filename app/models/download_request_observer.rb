class DownloadRequestObserver < ActiveRecord::Observer
  cattr_accessor :current_user

  def before_create(download_request)
    download_request.created_by = @@current_user
  end
end
