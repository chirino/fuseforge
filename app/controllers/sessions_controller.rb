class SessionsController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter :set_return_to
  
  def new
#    unless session[:return_to].blank?
#      cookies[REDIRECT_BACK_COOKIE_NAME] = { :value => FUSEFORGE_URL + session[:return_to], :domain => REDIRECT_BACK_COOKIE_DOMAIN_NAME }
#      session[:return_to] = nil
#    end
    redirect_to "#{FUSESOURCE_URL}/login?return_to=#{session[:return_to]}"
  end

  def destroy
    return_to = session[:return_to]
    reset_session
    redirect_to "#{FUSESOURCE_URL}/logout?return_to=#{return_to}"
  end
end
