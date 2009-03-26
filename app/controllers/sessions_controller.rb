class SessionsController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter :set_redirect_back_cookie
  
  def new
    cookies[REDIRECT_BACK_COOKIE_NAME] = { :value => FUSEFORGE_URL + session[:return_to], :domain => REDIRECT_BACK_COOKIE_DOMAIN_NAME } \
     unless session[:return_to].blank?
    redirect_to "#{FUSESOURCE_URL}/login"
  end

  def destroy
    reset_session
    redirect_to "#{FUSESOURCE_URL}/logout"
  end
end
