# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  CROWD_COOKIE_NAME="crowd.token_key"
  CROWD_CHECK_INTERVAL_SECONDS = 60

  before_filter :login_current_user
  before_filter :login_required
  before_filter :set_observers_current_user
  before_filter :set_return_to

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8a07951536f6e51cac250d06ec90de31'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  private
  
  def set_return_to
    session[:return_to] = request.env['HTTP_REFERER']
  end
  
  def set_observers_current_user
    UserActionObserver.current_user = ProjectObserver.current_user = @current_user
  end
      
  def logged_in?
    current_user != false
  end
  
  def current_user
    @current_user ||= false
  end
    
  helper_method :current_user, :logged_in?
    
  def login_current_user
    return if @current_user
    # Try first to use the session to figure out who is logged in to avoid hitting crowd 
    # all the time.
    @current_user = User.find_by_id(session[:user_id]) if session[:user_id]
    if @current_user
      # Expire the session if the crowd token changes.
      if @current_user.crowd_token != cookies[CROWD_COOKIE_NAME]
        @current_user.crowd_token = nil
        @current_user.save
        reset_session
        @current_user = false
      else
        return
      end
    end

    # Try to do a crowd login.
    if cookies[CROWD_COOKIE_NAME] 
      @current_user = User.authenticate_with_crowd_token(cookies[CROWD_COOKIE_NAME], request)
      # Keep track of the login so we can subseqently use the session
      if @current_user
        @current_user.crowd_token = cookies[CROWD_COOKIE_NAME]
        @current_user.save
        session[:user_id] = @current_user.id
        return;
      end
    end    
    @current_user = false    
  end  

  def login_required
    if !@current_user
      redirect_to "#{FUSESOURCE_URL}/login?return_to=#{external_url_to(request.request_uri)}"
    end    
  end
  
  #
  # Called when a user does not have access to the requested page.
  # if he is logged in, we show him a 401, otherwise we give him
  # a chance to login.
  def access_denied
    if @current_user
      render_401
    else
      redirect_to "#{FUSESOURCE_URL}/login?return_to=#{external_url_to(request.request_uri)}"
    end
  end
  
  def render_404 
	  respond_to do |format| 
	    format.html { render :file => "#{RAILS_ROOT}/app/views/shared/404.html.haml", :layout=>"new_look", :status => '404 Not Found' } 
      format.xml  { render :nothing => true, :status => '404 Not Found' } 
	  end 
	  true 
  end 

  def render_401
	  respond_to do |format| 
	    format.html { render :file => "#{RAILS_ROOT}/app/views/shared/401.html.haml", :layout=>"new_look", :status => '401 Unauthorized' } 
      format.xml  { render :nothing => true, :status => '401 Unauthorized' } 
	  end 
	  true 
  end
  
  def render_http_status(status_code, messages=[])
	  respond_to do |format| 
	    format.html { render :file => "#{RAILS_ROOT}/app/views/shared/http_status.html.haml", :layout=>"new_look", :status => status_code, :locals => {:status_code => status_code, :messages=>messages} } 
      format.xml  { render :nothing => true, :status => status_code } 
	  end 
	  true 
  end  
  
  def external_url_to(uri)
    if request.env['HTTP_X_FORWARDED_HOST']
      host = request.env['HTTP_X_FORWARDED_HOST'].to_s.split(/,\s*/).first
      return request.protocol + host + uri
    else
      return request.protocol + request.host_with_port + uri
    end
  end
  
  def forwarded_hosts
  end
        
  protected

  def rescue_action(e) 
	  case e 
      when Authorization::PermissionDenied
  	    access_denied 	    
  	  else 
  	    super 
	  end 
  end

  def rescue_action_in_public(e) 
	  case e 
  	  when ActiveRecord::RecordNotFound 
  	    render_404 
  	  else 
  	    @exception = e
        @rescues_path = File.dirname(rescues_path("stub"))
        @contents = render_to_string :file=>rescues_path('diagnostics'), :layout=>false
        puts rescues_path("layout")
        message = render_to_string :file=>rescues_path("layout"), :layout=>false
        Notifier.deliver_website_error(message)
  	    
  	    response = response_code_for_rescue(e)
  	    satus_code = interpret_status(response)
  	    render_http_status satus_code, ["We're sorry, but something went wrong.", "We've been notified about this issue and we'll take a look at it shortly."]
	  end 
	end

end
