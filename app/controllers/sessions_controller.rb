class SessionsController < ApplicationController
  skip_before_filter :login_required
  
  def new
    redirect_to "#{FUSESOURCE_URL}/login?return_to=#{session[:return_to]}"
  end

  def destroy
    reset_session
    redirect_to "#{FUSESOURCE_URL}/logout?return_to=#{FUSEFORGE_URL}"
  end

  private
  
  def set_return_to
    session[:return_to] = request.env['HTTP_REFERER'] if request.env['HTTP_REFERER'].include?('/forum')
  end
end
