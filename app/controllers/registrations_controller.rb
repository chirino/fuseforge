class RegistrationsController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter :set_return_to
  
  def new
    logger.info '-------------------------------------------'
    logger.info request.env['HTTP_REFERER'].inspect
    logger.info session[:return_to].inspect
    logger.info '-------------------------------------------'
    session[:return_to] = request.env['HTTP_REFERER'] if request.env['HTTP_REFERER'].include?('/forum') or \
     request.env['HTTP_REFERER'].include?('/wiki')
    session[:return_to] = params[:return_to] if params[:return_to] 
    redirect_to "#{FUSESOURCE_URL}/register?return_to=#{session[:return_to]}"
  end
end
