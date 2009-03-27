class SessionsController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter :set_return_to
  
  def new
    logger.info '--------------------------------'
    logger.info request.env['HTTP_REFERER'].inspect
    logger.info session[:return_to].inspect
    session[:return_to] = request.env['HTTP_REFERER'] if request.env['HTTP_REFERER'] =~ /[\/forum|\/wiki]/
    logger.info session[:return_to].inspect
    logger.info '---------------------------------'
    redirect_to "#{FUSESOURCE_URL}/login?return_to=#{session[:return_to]}"
  end

  def destroy
    reset_session
    redirect_to "#{FUSESOURCE_URL}/logout?return_to=#{FUSEFORGE_URL}"
  end
end
