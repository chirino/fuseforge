# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  CROWD_COOKIE_NAME="crowd.token_key"
  CROWD_CHECK_INTERVAL_SECONDS = 60

  before_filter :login_required
  before_filter :set_observers_current_user

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8a07951536f6e51cac250d06ec90de31'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  private
  
  def set_observers_current_user
    UserActionObserver.current_user = ProjectObserver.current_user = WikiPageAttachmentDownloadObserver.current_user = \
     DownloadRequestObserver.current_user = current_user
  end

  # overriding default implementation
  def authorized?       
    if need_to_check_with_crowd?
      # resetting the user_id will cause rails to login_from_cookie which checks with Crowd
      session[:user_id] = nil
    end      
    super
  end
      
  # overriding default implementation
  def login_from_cookie
    session[:last_crowd_check] = Time.now
    
    token = cookies[CROWD_COOKIE_NAME]
    user = User.authenticate_with_crowd_token(token, request)
    self.current_user = user    
  end
  
  def need_to_check_with_crowd?
    begin
      session[:last_crowd_check] < Time.now.ago(CROWD_CHECK_INTERVAL_SECONDS)
    rescue
      true
    end
  end
end
