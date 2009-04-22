class SessionsController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter :set_return_to
  
  def new
    session[:return_to] = request.env['HTTP_REFERER'] if request.env['HTTP_REFERER'].include?('/forum') or \
     request.env['HTTP_REFERER'].include?('/wiki') or params[:clicked] == 'yes'
    redirect_to "#{FUSESOURCE_URL}/login?return_to=#{session[:return_to]}"
  end

  def destroy
    reset_session
    redirect_to "#{FUSESOURCE_URL}/logout?return_to=#{external_url_to(root_path)}"
  end
end
